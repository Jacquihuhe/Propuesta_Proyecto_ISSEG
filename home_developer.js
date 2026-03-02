document.addEventListener('DOMContentLoaded', function() {
    // Verificar si hay sesión activa
    const currentUser = sessionStorage.getItem('currentUser');
    
    if (!currentUser) {
        window.location.href = 'login.html';
        return;
    }

    const userData = JSON.parse(currentUser);
    
    // Verificar que el usuario tenga rol de desarrollador
    if (userData.role !== 'developer') {
        if (userData.role === 'user') {
            window.location.href = 'home_cliente.html';
        } else if (userData.role === 'product_manager') {
            window.location.href = 'home_pm.html';
        } else {
            window.location.href = 'login.html';
        }
        return;
    }

    // Mostrar información del usuario
    const userNameElement = document.getElementById('userName');
    if (userNameElement) {
        const emailName = userData.username.split('@')[0];
        const displayName = emailName.charAt(0).toUpperCase() + emailName.slice(1);
        userNameElement.textContent = displayName;
    }

    // ========== SIDEBAR MENU ==========
    const sidebar = document.getElementById('sidebar');
    const menuToggle = document.getElementById('menuToggle');
    const sidebarClose = document.getElementById('sidebarClose');
    
    // Crear overlay para el sidebar
    const overlay = document.createElement('div');
    overlay.className = 'sidebar-overlay';
    document.body.appendChild(overlay);
    
    // Abrir sidebar
    menuToggle.addEventListener('click', function() {
        sidebar.classList.add('open');
        overlay.classList.add('active');
    });
    
    // Cerrar sidebar con botón X
    sidebarClose.addEventListener('click', function() {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
    });
    
    // Cerrar sidebar al hacer click en overlay
    overlay.addEventListener('click', function() {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
    });

    // ========== NOTIFICATIONS ==========
    const notificationsBtn = document.getElementById('notificationsBtn');
    const notificationsPanel = document.getElementById('notificationsPanel');
    const notificationsList = document.getElementById('notificationsList');
    const notificationBadge = document.getElementById('notificationBadge');
    const markAllReadBtn = document.getElementById('markAllRead');
    
    // Notificaciones de ejemplo para desarrolladores
    const mockNotifications = [
        {
            id: 1,
            type: 'warning',
            title: 'Nueva Solicitud Urgente',
            message: 'Se ha asignado una falla urgente en el sistema de nómina',
            time: 'Hace 10 minutos',
            read: false
        },
        {
            id: 2,
            type: 'info',
            title: 'Solicitud Aprobada',
            message: 'REQ-2026-007 ha sido aprobada y asignada a tu equipo',
            time: 'Hace 30 minutos',
            read: false
        },
        {
            id: 3,
            type: 'success',
            title: 'Código Revisado',
            message: 'Tu pull request para REQ-2026-002 ha sido aprobado',
            time: 'Hace 1 hora',
            read: false
        },
        {
            id: 4,
            type: 'info',
            title: 'Comentario Nuevo',
            message: 'El cliente agregó comentarios en REQ-2026-005',
            time: 'Hace 2 horas',
            read: false
        },
        {
            id: 5,
            type: 'danger',
            title: 'Error en Producción',
            message: 'Se detectó un error crítico en el módulo de reportes',
            time: 'Hace 3 horas',
            read: false
        },
        {
            id: 6,
            type: 'success',
            title: 'Deploy Exitoso',
            message: 'La versión 2.3.1 se desplegó correctamente',
            time: 'Ayer',
            read: true
        }
    ];
    
    // Renderizar notificaciones
    function renderNotifications() {
        const unreadCount = mockNotifications.filter(n => !n.read).length;
        
        // Actualizar badge
        if (unreadCount > 0) {
            notificationBadge.textContent = unreadCount;
            notificationBadge.style.display = 'block';
        } else {
            notificationBadge.style.display = 'none';
        }
        
        // Renderizar lista
        notificationsList.innerHTML = mockNotifications.map(n => `
            <div class="notification-item ${n.read ? '' : 'unread'}" data-id="${n.id}">
                <div class="notification-icon ${n.type}">
                    ${getNotificationIcon(n.type)}
                </div>
                <div class="notification-content">
                    <div class="notification-title">${n.title}</div>
                    <div class="notification-message">${n.message}</div>
                    <div class="notification-time">${n.time}</div>
                </div>
            </div>
        `).join('');
        
        // Agregar eventos de click a notificaciones
        document.querySelectorAll('.notification-item').forEach(item => {
            item.addEventListener('click', function() {
                const notifId = parseInt(this.dataset.id);
                markAsRead(notifId);
            });
        });
    }
    
    function getNotificationIcon(type) {
        const icons = {
            success: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>',
            info: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>',
            warning: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>',
            danger: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>'
        };
        return icons[type] || icons.info;
    }
    
    function markAsRead(notifId) {
        const notification = mockNotifications.find(n => n.id === notifId);
        if (notification) {
            notification.read = true;
            renderNotifications();
        }
    }
    
    // Toggle panel de notificaciones
    notificationsBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        notificationsPanel.classList.toggle('active');
    });
    
    // Marcar todas como leídas
    markAllReadBtn.addEventListener('click', function() {
        mockNotifications.forEach(n => n.read = true);
        renderNotifications();
    });
    
    // Cerrar panel al hacer click fuera
    document.addEventListener('click', function(e) {
        if (!notificationsPanel.contains(e.target) && !notificationsBtn.contains(e.target)) {
            notificationsPanel.classList.remove('active');
        }
    });
    
    // Renderizar notificaciones iniciales
    renderNotifications();

    // Manejar cierre de sesión
    const btnLogout = document.getElementById('btnLogout');
    if (btnLogout) {
        btnLogout.addEventListener('click', function() {
            if (confirm('¿Estás seguro que deseas cerrar sesión?')) {
                sessionStorage.removeItem('currentUser');
                window.location.href = 'login.html';
            }
        });
    }

    // Cargar datos de solicitudes
    loadRequests();
    
    // Configurar filtros
    setupFilters();
});

// Datos de ejemplo de solicitudes
const mockRequests = [
    {
        id: 'REQ-2026-001',
        type: 'falla_urgente',
        solicitante: 'Ana García',
        area: 'Prestaciones',
        description: 'Sistema de nómina caído, no permite procesar pagos',
        priority: 'alta',
        status: 'urgente',
        date: '2026-02-26'
    },
    {
        id: 'REQ-2026-002',
        type: 'modificacion',
        solicitante: 'Carlos Ruiz',
        area: 'RH',
        description: 'Agregar campo de CURP en formulario de empleados',
        priority: 'media',
        status: 'en_desarrollo',
        date: '2026-02-25'
    },
    {
        id: 'REQ-2026-003',
        type: 'nuevo_sistema',
        solicitante: 'María López',
        area: 'Finanzas',
        description: 'Sistema de control de gastos y presupuestos',
        priority: 'media',
        status: 'pendiente',
        date: '2026-02-24'
    },
    {
        id: 'REQ-2026-004',
        type: 'falla_urgente',
        solicitante: 'Pedro Sánchez',
        area: 'Cobranza',
        description: 'Error en cálculo de intereses moratorios',
        priority: 'alta',
        status: 'urgente',
        date: '2026-02-26'
    },
    {
        id: 'REQ-2026-005',
        type: 'requerimientos',
        solicitante: 'Laura Martínez',
        area: 'Sistemas',
        description: 'Documentación técnica para portal de afiliados',
        priority: 'media',
        status: 'en_desarrollo',
        date: '2026-02-23'
    },
    {
        id: 'REQ-2026-006',
        type: 'modificacion',
        solicitante: 'José Hernández',
        area: 'Prestaciones',
        description: 'Optimizar tiempos de respuesta en consultas',
        priority: 'baja',
        status: 'pendiente',
        date: '2026-02-22'
    },
    {
        id: 'REQ-2026-007',
        type: 'nuevo_sistema',
        solicitante: 'Diana Torres',
        area: 'RH',
        description: 'Portal de capacitación en línea para empleados',
        priority: 'media',
        status: 'pendiente',
        date: '2026-02-21'
    },
    {
        id: 'REQ-2026-008',
        type: 'modificacion',
        solicitante: 'Roberto Flores',
        area: 'Jurídico',
        description: 'Agregar firma electrónica en documentos',
        priority: 'alta',
        status: 'en_desarrollo',
        date: '2026-02-20'
    },
    {
        id: 'REQ-2026-009',
        type: 'modificacion',
        solicitante: 'Sandra Jiménez',
        area: 'Finanzas',
        description: 'Reporte de conciliaciones bancarias automático',
        priority: 'media',
        status: 'completada',
        date: '2026-02-15'
    },
    {
        id: 'REQ-2026-010',
        type: 'modificacion',
        solicitante: 'Miguel Ángel Ramos',
        area: 'Cobranza',
        description: 'Integración con pasarela de pagos en línea',
        priority: 'alta',
        status: 'en_desarrollo',
        date: '2026-02-18'
    }
];

let currentRequests = [...mockRequests];

function loadRequests() {
    renderRequests(currentRequests);
    updateStats();
}

function renderRequests(requests) {
    const tbody = document.getElementById('requestsTableBody');
    const emptyState = document.getElementById('emptyState');
    const tableContainer = document.querySelector('.requests-table-container');
    
    if (requests.length === 0) {
        tableContainer.style.display = 'none';
        emptyState.style.display = 'block';
        return;
    }
    
    tableContainer.style.display = 'block';
    emptyState.style.display = 'none';
    
    tbody.innerHTML = requests.map(req => `
        <tr>
            <td><span class="request-id">${req.id}</span></td>
            <td><span class="request-type ${req.type}">${getTypeLabel(req.type)}</span></td>
            <td>${req.solicitante}</td>
            <td>${req.area}</td>
            <td><span class="request-description" title="${req.description}">${req.description}</span></td>
            <td>
                <span class="request-priority">
                    <span class="priority-dot ${req.priority}"></span>
                    ${getPriorityLabel(req.priority)}
                </span>
            </td>
            <td><span class="request-status ${req.status}">${getStatusLabel(req.status)}</span></td>
            <td>${formatDate(req.date)}</td>
            <td>
                <div class="action-buttons">
                    <button class="btn-action btn-view" onclick="viewRequest('${req.id}')">Ver</button>
                    <button class="btn-action btn-edit" onclick="editRequest('${req.id}')">Editar</button>
                </div>
            </td>
        </tr>
    `).join('');
}

function getTypeLabel(type) {
    const labels = {
        'nuevo_sistema': 'Nuevo Sistema',
        'modificacion': 'Modificación',
        'requerimientos': 'Requerimientos',
        'falla_urgente': 'Falla Urgente'
    };
    return labels[type] || type;
}

function getStatusLabel(status) {
    const labels = {
        'pendiente': 'Pendiente',
        'en_desarrollo': 'En Desarrollo',
        'completada': 'Completada',
        'urgente': 'Urgente'
    };
    return labels[status] || status;
}

function getPriorityLabel(priority) {
    const labels = {
        'alta': 'Alta',
        'media': 'Media',
        'baja': 'Baja'
    };
    return labels[priority] || priority;
}

function formatDate(dateStr) {
    const date = new Date(dateStr);
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return date.toLocaleDateString('es-MX', options);
}

function updateStats() {
    const stats = {
        pendientes: currentRequests.filter(r => r.status === 'pendiente').length,
        enDesarrollo: currentRequests.filter(r => r.status === 'en_desarrollo').length,
        completadas: currentRequests.filter(r => r.status === 'completada').length,
        urgentes: currentRequests.filter(r => r.status === 'urgente').length
    };
    
    document.getElementById('statPendientes').textContent = stats.pendientes;
    document.getElementById('statEnDesarrollo').textContent = stats.enDesarrollo;
    document.getElementById('statCompletadas').textContent = stats.completadas;
    document.getElementById('statUrgentes').textContent = stats.urgentes;
}

function setupFilters() {
    const filterStatus = document.getElementById('filterStatus');
    const filterType = document.getElementById('filterType');
    
    filterStatus.addEventListener('change', applyFilters);
    filterType.addEventListener('change', applyFilters);
}

function applyFilters() {
    const filterStatus = document.getElementById('filterStatus').value;
    const filterType = document.getElementById('filterType').value;
    
    let filtered = [...mockRequests];
    
    if (filterStatus !== 'all') {
        filtered = filtered.filter(r => r.status === filterStatus);
    }
    
    if (filterType !== 'all') {
        filtered = filtered.filter(r => r.type === filterType);
    }
    
    currentRequests = filtered;
    renderRequests(currentRequests);
}

// Funciones de filtrado rápido
window.filterRequests = function(status) {
    document.getElementById('filterStatus').value = status;
    applyFilters();
};

window.showAllRequests = function() {
    document.getElementById('filterStatus').value = 'all';
    document.getElementById('filterType').value = 'all';
    applyFilters();
};

// Funciones de acción sobre solicitudes
window.viewRequest = function(id) {
    const request = mockRequests.find(r => r.id === id);
    if (request) {
        alert(`📄 Detalles de Solicitud\n\nID: ${request.id}\nTipo: ${getTypeLabel(request.type)}\nSolicitante: ${request.solicitante}\nÁrea: ${request.area}\nDescripción: ${request.description}\nPrioridad: ${getPriorityLabel(request.priority)}\nEstado: ${getStatusLabel(request.status)}\nFecha: ${formatDate(request.date)}`);
    }
};

window.editRequest = function(id) {
    const request = mockRequests.find(r => r.id === id);
    if (request) {
        const newStatus = prompt(`Cambiar estado de la solicitud ${id}\n\nEstado actual: ${getStatusLabel(request.status)}\n\nOpciones:\n- pendiente\n- en_desarrollo\n- completada\n- urgente\n\nIngresa el nuevo estado:`);
        
        if (newStatus && ['pendiente', 'en_desarrollo', 'completada', 'urgente'].includes(newStatus)) {
            request.status = newStatus;
            renderRequests(currentRequests);
            updateStats();
            alert('✅ Estado actualizado correctamente');
        } else if (newStatus) {
            alert('❌ Estado no válido');
        }
    }
};
