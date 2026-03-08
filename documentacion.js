// ============================================
// Documentación - Repositorio de Documentos
// ============================================

const REQUESTS_STORAGE_KEY = 'developerRequests';

// Estado de la aplicación
let allDocuments = [];
let currentFilter = 'todos';
let currentSearchTerm = '';

// ============================================
// Inicialización
// ============================================
document.addEventListener('DOMContentLoaded', function() {
    checkAuthentication();
    loadUserInfo();
    initializeEventListeners();
    loadAndRenderDocuments();
});

// ============================================
// Autenticación
// ============================================
function checkAuthentication() {
    const currentUser = sessionStorage.getItem('currentUser');
    if (!currentUser) {
        window.location.href = 'login.html';
        return;
    }
}

function loadUserInfo() {
    const currentUser = sessionStorage.getItem('currentUser');
    if (currentUser) {
        const user = JSON.parse(currentUser);
        document.getElementById('userName').textContent = user.name || user.email;
        document.getElementById('userRole').textContent = getRoleDisplay(user.role);
    }
}

function getRoleDisplay(role) {
    const roles = {
        'developer': 'Desarrollador',
        'pm': 'Project Manager',
        'client': 'Cliente'
    };
    return roles[role] || role;
}

// ============================================
// Event Listeners
// ============================================
function initializeEventListeners() {
    // Sidebar toggle
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    
    if (menuToggle) {
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('active');
            overlay.classList.toggle('active');
        });
    }
    
    if (overlay) {
        overlay.addEventListener('click', () => {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
        });
    }

    // Notifications toggle
    const notificationsToggle = document.getElementById('notificationsToggle');
    const notificationsPanel = document.getElementById('notificationsPanel');
    
    if (notificationsToggle) {
        notificationsToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            notificationsPanel.classList.toggle('active');
        });
    }

    document.addEventListener('click', (e) => {
        if (notificationsPanel && !notificationsPanel.contains(e.target) && e.target !== notificationsToggle) {
            notificationsPanel.classList.remove('active');
        }
    });

    // Logout
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', () => {
            sessionStorage.removeItem('currentUser');
            window.location.href = 'login.html';
        });
    }

    // Search
    const searchInput = document.getElementById('docSearch');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            currentSearchTerm = e.target.value.toLowerCase();
            filterAndRenderDocuments();
        });
    }

    // Filter buttons
    const filterButtons = document.querySelectorAll('.filter-btn');
    filterButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            filterButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentFilter = btn.dataset.filter;
            filterAndRenderDocuments();
        });
    });

    // Modal close
    const modalClose = document.getElementById('modalClose');
    const documentModal = document.getElementById('documentModal');
    
    if (modalClose) {
        modalClose.addEventListener('click', () => {
            documentModal.classList.remove('active');
        });
    }

    if (documentModal) {
        documentModal.addEventListener('click', (e) => {
            if (e.target === documentModal) {
                documentModal.classList.remove('active');
            }
        });
    }
}

// ============================================
// Carga de Documentos
// ============================================
function loadAndRenderDocuments() {
    allDocuments = generateDocumentsFromRequests();
    updateStatistics(allDocuments);
    updateFilterCounts(allDocuments);
    filterAndRenderDocuments();
}

function generateDocumentsFromRequests() {
    const requests = JSON.parse(localStorage.getItem(REQUESTS_STORAGE_KEY)) || [];
    const documents = [];

    // Generar documentos de ejemplo para cada solicitud
    requests.forEach((request, index) => {
        // Cada solicitud puede tener múltiples documentos
        const numDocs = Math.floor(Math.random() * 3) + 1; // 1-3 documentos por solicitud
        
        for (let i = 0; i < numDocs; i++) {
            documents.push(generateDocument(request, i));
        }
    });

    return documents;
}

function generateDocument(request, docIndex) {
    const fileTypes = [
        { ext: 'pdf', name: 'Manual', size: 2457600 },
        { ext: 'docx', name: 'Especificaciones', size: 1024000 },
        { ext: 'xlsx', name: 'Datos', size: 512000 },
        { ext: 'png', name: 'Diagrama', size: 819200 },
        { ext: 'drawio', name: 'Flujo', size: 256000 },
        { ext: 'pdf', name: 'Análisis', size: 3145728 },
        { ext: 'docx', name: 'Requerimientos', size: 768000 },
        { ext: 'jpg', name: 'Mockup', size: 1536000 },
        { ext: 'vsdx', name: 'Arquitectura', size: 2048000 }
    ];

    const fileType = fileTypes[Math.floor(Math.random() * fileTypes.length)];
    const uploadDate = new Date(request.date);
    uploadDate.setHours(uploadDate.getHours() + docIndex);

    return {
        id: `doc-${request.id}-${docIndex}`,
        requestId: request.id,
        requestType: request.type,
        requestDescription: request.description,
        area: request.area,
        solicitante: request.solicitante,
        fileName: `${fileType.name}_${request.area.replace(/\s+/g, '_')}_${docIndex + 1}.${fileType.ext}`,
        fileType: fileType.ext,
        fileSize: fileType.size + Math.floor(Math.random() * 100000),
        uploadDate: uploadDate.toISOString(),
        uploadedBy: request.solicitante,
        status: request.status
    };
}

// ============================================
// Filtrado y Búsqueda
// ============================================
function filterAndRenderDocuments() {
    let filteredDocs = [...allDocuments];

    // Aplicar filtro por tipo
    if (currentFilter !== 'todos') {
        filteredDocs = filteredDocs.filter(doc => doc.requestType === currentFilter);
    }

    // Aplicar búsqueda
    if (currentSearchTerm) {
        filteredDocs = filteredDocs.filter(doc => {
            return (
                doc.fileName.toLowerCase().includes(currentSearchTerm) ||
                doc.area.toLowerCase().includes(currentSearchTerm) ||
                doc.requestId.toLowerCase().includes(currentSearchTerm) ||
                doc.requestDescription.toLowerCase().includes(currentSearchTerm)
            );
        });
    }

    renderDocumentsGrid(filteredDocs);
}

// ============================================
// Renderizado
// ============================================
function renderDocumentsGrid(documents) {
    const grid = document.getElementById('documentsGrid');
    const emptyState = document.getElementById('emptyState');

    if (documents.length === 0) {
        grid.style.display = 'none';
        emptyState.style.display = 'flex';
        return;
    }

    grid.style.display = 'grid';
    emptyState.style.display = 'none';

    grid.innerHTML = documents.map(doc => createDocumentCard(doc)).join('');

    // Agregar event listeners a las tarjetas
    documents.forEach(doc => {
        const card = document.getElementById(`card-${doc.id}`);
        if (card) {
            card.addEventListener('click', () => showDocumentModal(doc));
        }

        // Event listeners para los botones de acción (evitar propagación)
        const viewBtn = document.getElementById(`view-${doc.id}`);
        const downloadBtn = document.getElementById(`download-${doc.id}`);

        if (viewBtn) {
            viewBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                viewDocument(doc);
            });
        }

        if (downloadBtn) {
            downloadBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                downloadDocument(doc);
            });
        }
    });
}

function createDocumentCard(doc) {
    const fileTypeClass = doc.fileType.toLowerCase();
    const requestTypeLabel = getRequestTypeLabel(doc.requestType);
    const formattedDate = formatDate(doc.uploadDate);
    const formattedSize = formatFileSize(doc.fileSize);

    return `
        <div class="document-card" id="card-${doc.id}">
            <div class="document-header">
                <div class="file-type-icon ${fileTypeClass}">
                    ${doc.fileType}
                </div>
                <div class="document-info">
                    <div class="document-title" title="${doc.fileName}">${doc.fileName}</div>
                    <div class="document-meta">
                        <span>Solicitud: ${doc.requestId}</span>
                        <span>Área: ${doc.area}</span>
                    </div>
                </div>
            </div>
            <div class="document-tags">
                <span class="doc-tag ${doc.requestType}">${requestTypeLabel}</span>
            </div>
            <div class="document-footer">
                <span class="document-size">${formattedSize}</span>
                <div class="document-actions">
                    <button class="doc-action-btn" id="view-${doc.id}" title="Ver detalles">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                    </button>
                    <button class="doc-action-btn" id="download-${doc.id}" title="Descargar">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="7 10 12 15 17 10"></polyline>
                            <line x1="12" y1="15" x2="12" y2="3"></line>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    `;
}

// ============================================
// Modal de Detalles
// ============================================
function showDocumentModal(doc) {
    const modal = document.getElementById('documentModal');
    const modalBody = document.getElementById('modalBody');

    const fileTypeClass = doc.fileType.toLowerCase();
    const requestTypeLabel = getRequestTypeLabel(doc.requestType);
    const formattedDate = formatDate(doc.uploadDate);
    const formattedDateTime = formatDateTime(doc.uploadDate);
    const formattedSize = formatFileSize(doc.fileSize);

    modalBody.innerHTML = `
        <div class="modal-document-info">
            <div class="modal-file-preview">
                <div class="modal-file-icon file-type-icon ${fileTypeClass}">
                    ${doc.fileType}
                </div>
                <div class="modal-file-details">
                    <h4>${doc.fileName}</h4>
                    <p><strong>Tamaño:</strong> ${formattedSize}</p>
                    <p><strong>Tipo:</strong> ${doc.fileType.toUpperCase()}</p>
                </div>
            </div>

            <div class="modal-section">
                <h4>Información de la Solicitud</h4>
                <p><strong>ID:</strong> ${doc.requestId}</p>
                <p><strong>Tipo:</strong> ${requestTypeLabel}</p>
                <p><strong>Área:</strong> ${doc.area}</p>
                <p><strong>Descripción:</strong> ${doc.requestDescription}</p>
            </div>

            <div class="modal-section">
                <h4>Detalles del Archivo</h4>
                <p><strong>Subido por:</strong> ${doc.uploadedBy}</p>
                <p><strong>Fecha de carga:</strong> ${formattedDateTime}</p>
                <p><strong>Estado de solicitud:</strong> <span class="doc-tag ${doc.requestType}">${requestTypeLabel}</span></p>
            </div>

            <div class="modal-actions">
                <button class="modal-btn modal-btn-primary" onclick="downloadDocument(${JSON.stringify(doc).replace(/"/g, '&quot;')})">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    Descargar Archivo
                </button>
                <button class="modal-btn modal-btn-secondary" onclick="viewDocument(${JSON.stringify(doc).replace(/"/g, '&quot;')})">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                    Ver Documento
                </button>
            </div>
        </div>
    `;

    modal.classList.add('active');
}

// ============================================
// Acciones de Documento
// ============================================
function viewDocument(doc) {
    alert(`Ver documento: ${doc.fileName}\n\nEsta es una demostración. En producción, aquí se abriría el visor de documentos.`);
}

function downloadDocument(doc) {
    alert(`Descargar: ${doc.fileName}\nTamaño: ${formatFileSize(doc.fileSize)}\n\nEsta es una demostración. En producción, aquí se descargaría el archivo.`);
}

// ============================================
// Estadísticas
// ============================================
function updateStatistics(documents) {
    // Total de documentos
    document.getElementById('total-documents').textContent = documents.length;

    // Total de solicitudes únicas
    const uniqueRequests = new Set(documents.map(doc => doc.requestId));
    document.getElementById('total-requests').textContent = uniqueRequests.size;

    // Tamaño total
    const totalSize = documents.reduce((sum, doc) => sum + doc.fileSize, 0);
    document.getElementById('total-size').textContent = formatFileSize(totalSize);
}

function updateFilterCounts(documents) {
    // Contar todos
    document.getElementById('count-todos').textContent = documents.length;

    // Contar por tipo
    const countsByType = {
        requerimientos: 0,
        modificacion: 0,
        urgente: 0
    };

    documents.forEach(doc => {
        if (countsByType.hasOwnProperty(doc.requestType)) {
            countsByType[doc.requestType]++;
        }
    });

    document.getElementById('count-requerimientos').textContent = countsByType.requerimientos;
    document.getElementById('count-modificacion').textContent = countsByType.modificacion;
    document.getElementById('count-urgente').textContent = countsByType.urgente;
}

// ============================================
// Utilidades
// ============================================
function getRequestTypeLabel(type) {
    const labels = {
        'requerimientos': 'Requerimiento',
        'modificacion': 'Modificación',
        'urgente': 'Urgente',
        'viabilidad': 'Viabilidad'
    };
    return labels[type] || type;
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

function formatDate(dateString) {
    const date = new Date(dateString);
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return date.toLocaleDateString('es-ES', options);
}

function formatDateTime(dateString) {
    const date = new Date(dateString);
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    };
    return date.toLocaleDateString('es-ES', options);
}
