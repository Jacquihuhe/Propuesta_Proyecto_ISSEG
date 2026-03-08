const REQUESTS_STORAGE_KEY = 'developerRequests';

const defaultRequests = [
    {
        id: 'REQ-2026-001',
        type: 'falla_urgente',
        solicitante: 'Ana Garcia',
        area: 'Prestaciones',
        description: 'Sistema de nomina caido, no permite procesar pagos',
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
        solicitante: 'Maria Lopez',
        area: 'Finanzas',
        description: 'Sistema de control de gastos y presupuestos',
        priority: 'media',
        status: 'pendiente',
        date: '2026-02-24'
    },
    {
        id: 'REQ-2026-004',
        type: 'falla_urgente',
        solicitante: 'Pedro Sanchez',
        area: 'Cobranza',
        description: 'Error en calculo de intereses moratorios',
        priority: 'alta',
        status: 'urgente',
        date: '2026-02-26'
    },
    {
        id: 'REQ-2026-005',
        type: 'requerimientos',
        solicitante: 'Laura Martinez',
        area: 'Sistemas',
        description: 'Documentacion tecnica para portal de afiliados',
        priority: 'media',
        status: 'en_desarrollo',
        date: '2026-02-23'
    }
];

let allRequests = [];
let filteredRequests = [];
let selectedRequestId = null;
let editMode = false;

document.addEventListener('DOMContentLoaded', function() {
    const currentUser = sessionStorage.getItem('currentUser');
    const userNameElement = document.getElementById('userName');

    if (currentUser) {
        const userData = JSON.parse(currentUser);
        if (userData.role === 'developer' && userNameElement) {
            const emailName = userData.username.split('@')[0];
            userNameElement.textContent = emailName.charAt(0).toUpperCase() + emailName.slice(1);
        }
    } else if (userNameElement) {
        // Permite probar la vista localmente sin forzar login.
        userNameElement.textContent = 'Desarrollador';
    }

    setupSidebar();
    setupNotifications();
    setupLogout();
    setupFilters();
    setupTableActions();
    setupEditor();

    allRequests = readRequests();
    filteredRequests = [...allRequests];

    renderTable();
    renderStats();

    const params = new URLSearchParams(window.location.search);
    const id = params.get('id');
    const mode = params.get('mode');
    if (id && mode) {
        openRequest(id, mode === 'edit');
    }
});

function readRequests() {
    const raw = localStorage.getItem(REQUESTS_STORAGE_KEY);
    if (!raw) {
        localStorage.setItem(REQUESTS_STORAGE_KEY, JSON.stringify(defaultRequests));
        return [...defaultRequests];
    }

    try {
        const parsed = JSON.parse(raw);
        return Array.isArray(parsed) ? parsed : [...defaultRequests];
    } catch (error) {
        localStorage.setItem(REQUESTS_STORAGE_KEY, JSON.stringify(defaultRequests));
        return [...defaultRequests];
    }
}

function persistRequests() {
    localStorage.setItem(REQUESTS_STORAGE_KEY, JSON.stringify(allRequests));
}

function setupSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    const menuToggle = document.getElementById('menuToggle');
    const sidebarClose = document.getElementById('sidebarClose');

    if (!sidebar || !overlay || !menuToggle || !sidebarClose) {
        return;
    }

    menuToggle.addEventListener('click', function() {
        sidebar.classList.add('open');
        overlay.classList.add('active');
    });

    sidebarClose.addEventListener('click', function() {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
    });

    overlay.addEventListener('click', function() {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
    });
}

function setupNotifications() {
    const notificationsBtn = document.getElementById('notificationsBtn');
    const panel = document.getElementById('notificationsPanel');
    const list = document.getElementById('notificationsList');
    const badge = document.getElementById('notificationBadge');
    const markAll = document.getElementById('markAllRead');

    if (!notificationsBtn || !panel || !list || !badge || !markAll) {
        return;
    }

    const notifications = [
        { id: 1, title: 'Nueva solicitud urgente', time: 'Hace 10 min', read: false },
        { id: 2, title: 'Comentario del PM', time: 'Hace 45 min', read: false }
    ];

    function drawNotifications() {
        const unread = notifications.filter(function(n) { return !n.read; }).length;
        badge.style.display = unread ? 'block' : 'none';
        badge.textContent = String(unread);

        list.innerHTML = notifications.map(function(n) {
            return '<div class="notification-item ' + (n.read ? '' : 'unread') + '">' +
                '<div class="notification-icon info">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>' +
                '</div>' +
                '<div class="notification-content"><div class="notification-title">' + n.title + '</div><div class="notification-time">' + n.time + '</div></div>' +
                '</div>';
        }).join('');
    }

    notificationsBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        panel.classList.toggle('active');
    });

    markAll.addEventListener('click', function() {
        notifications.forEach(function(n) { n.read = true; });
        drawNotifications();
    });

    document.addEventListener('click', function(e) {
        if (!panel.contains(e.target) && !notificationsBtn.contains(e.target)) {
            panel.classList.remove('active');
        }
    });

    drawNotifications();
}

function setupLogout() {
    const btnLogout = document.getElementById('btnLogout');
    if (!btnLogout) {
        return;
    }

    const hasSession = !!sessionStorage.getItem('currentUser');
    if (!hasSession) {
        btnLogout.classList.add('btn-logout-hidden');
        return;
    }

    btnLogout.addEventListener('click', function() {
        if (confirm('Deseas cerrar sesion?')) {
            sessionStorage.removeItem('currentUser');
            globalThis.location.href = 'login.html';
        }
    });
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

    filteredRequests = allRequests.filter(function(req) {
        const matchesStatus = filterStatus === 'all' || req.status === filterStatus;
        const matchesType = filterType === 'all' || req.type === filterType;
        return matchesStatus && matchesType;
    });

    renderTable();
}

function renderTable() {
    const tbody = document.getElementById('tasksTableBody');

    tbody.innerHTML = filteredRequests.map(function(req) {
        return '<tr>' +
            '<td><span class="request-id">' + req.id + '</span></td>' +
            '<td><span class="request-type ' + req.type + '">' + getTypeLabel(req.type) + '</span></td>' +
            '<td>' + req.solicitante + '</td>' +
            '<td>' + req.area + '</td>' +
            '<td><span class="request-priority"><span class="priority-dot ' + req.priority + '"></span>' + getPriorityLabel(req.priority) + '</span></td>' +
            '<td><span class="request-status ' + req.status + '">' + getStatusLabel(req.status) + '</span></td>' +
            '<td>' + formatDate(req.date) + '</td>' +
            '<td><div class="table-action-buttons">' +
            '<button class="btn-icon btn-icon-view" title="Ver detalles" data-action="view" data-id="' + req.id + '">' +
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>' +
            '</button>' +
            '<button class="btn-icon btn-icon-edit" title="Editar solicitud" data-action="edit" data-id="' + req.id + '">' +
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>' +
            '</button>' +
            '</div></td>' +
            '</tr>';
    }).join('');
}

function renderStats() {
    const stats = {
        pendientes: allRequests.filter(function(r) { return r.status === 'pendiente'; }).length,
        enDesarrollo: allRequests.filter(function(r) { return r.status === 'en_desarrollo'; }).length,
        completadas: allRequests.filter(function(r) { return r.status === 'completada'; }).length,
        urgentes: allRequests.filter(function(r) { return r.status === 'urgente'; }).length
    };

    document.getElementById('statPendientes').textContent = stats.pendientes;
    document.getElementById('statEnDesarrollo').textContent = stats.enDesarrollo;
    document.getElementById('statCompletadas').textContent = stats.completadas;
    document.getElementById('statUrgentes').textContent = stats.urgentes;
}

function setupTableActions() {
    const tbody = document.getElementById('tasksTableBody');
    if (!tbody) {
        return;
    }

    tbody.addEventListener('click', function(event) {
        const actionButton = event.target.closest('button[data-action]');
        if (!actionButton) {
            return;
        }

        const action = actionButton.dataset.action;
        const id = actionButton.dataset.id;
        if (!id) {
            return;
        }

        if (action === 'view') {
            openRequest(id, false);
            return;
        }

        if (action === 'edit') {
            openRequest(id, true);
            return;
        }
    });
}

function setupEditor() {
    const form = document.getElementById('taskEditorForm');
    const cancelEditBtn = document.getElementById('cancelEdit');

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        if (!selectedRequestId || !editMode) {
            return;
        }

        const request = allRequests.find(function(item) { return item.id === selectedRequestId; });
        if (!request) {
            return;
        }

        request.status = document.getElementById('editStatus').value;
        request.priority = document.getElementById('editPriority').value;
        request.description = document.getElementById('editDescription').value.trim();

        persistRequests();
        applyFilters();
        renderStats();
        openRequest(request.id, false);
        alert('Cambios guardados correctamente.');
    });

    cancelEditBtn.addEventListener('click', function() {
        if (!selectedRequestId) {
            closeEditor();
            return;
        }
        openRequest(selectedRequestId, false);
    });
}

window.openRequest = function(id, shouldEdit) {
    const request = allRequests.find(function(item) { return item.id === id; });
    if (!request) {
        return;
    }

    selectedRequestId = id;
    editMode = shouldEdit;

    const editorEmpty = document.getElementById('editorEmpty');
    const taskEditorForm = document.getElementById('taskEditorForm');

    editorEmpty.style.display = 'none';
    taskEditorForm.classList.remove('is-hidden');

    document.getElementById('editId').value = request.id;
    document.getElementById('editDate').value = formatDate(request.date);
    document.getElementById('editStatus').value = request.status;
    document.getElementById('editPriority').value = request.priority;
    document.getElementById('editDescription').value = request.description;

    const modeLabel = document.getElementById('editorModeLabel');
    modeLabel.textContent = getStatusLabel(request.status);
    modeLabel.className = 'request-status ' + request.status;
    console.log('🎨 Badge actualizado:', getStatusLabel(request.status), 'clase:', request.status);

    document.getElementById('editStatus').disabled = !shouldEdit;
    document.getElementById('editPriority').disabled = !shouldEdit;
    document.getElementById('editDescription').disabled = !shouldEdit;
}

function closeEditor() {
    selectedRequestId = null;
    editMode = false;
    document.getElementById('taskEditorForm').classList.add('is-hidden');
    document.getElementById('editorEmpty').classList.remove('is-hidden');
    const modeLabel = document.getElementById('editorModeLabel');
    modeLabel.textContent = 'Sin seleccionar';
    modeLabel.className = 'request-status pendiente';
}

function getTypeLabel(type) {
    const labels = {
        nuevo_sistema: 'Nuevo Sistema',
        modificacion: 'Modificacion',
        requerimientos: 'Requerimientos',
        falla_urgente: 'Falla Urgente'
    };
    return labels[type] || type;
}

function getStatusLabel(status) {
    const labels = {
        pendiente: 'Pendiente',
        en_desarrollo: 'En Desarrollo',
        completada: 'Completada',
        urgente: 'Urgente'
    };
    return labels[status] || status;
}

function getPriorityLabel(priority) {
    const labels = {
        alta: 'Alta',
        media: 'Media',
        baja: 'Baja'
    };
    return labels[priority] || priority;
}

function formatDate(dateStr) {
    const date = new Date(dateStr);
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return date.toLocaleDateString('es-MX', options);
}

function showStatusMenu(requestId, buttonElement) {
        console.log('🎯 Abriendo menú de estado para:', requestId);
    const existingMenu = document.querySelector('.status-dropdown-menu');
    if (existingMenu) {
            console.log('⚠️ Cerrando menú existente');
        existingMenu.remove();
        return;
    }

    const request = allRequests.find(function(r) { return r.id === requestId; });
        console.log('❌ No se encontró la solicitud');
        console.log('✅ Solicitud encontrada, estado actual:', request.status);
    if (!request) {
        return;
    }

    const menu = document.createElement('div');
    menu.className = 'status-dropdown-menu';
    menu.innerHTML = '<div class="status-menu-item" data-status="pendiente">' +
        '<span class="status-dot pendiente"></span>Pendiente' +
        '</div>' +
        '<div class="status-menu-item" data-status="en_desarrollo">' +
        '<span class="status-dot en_desarrollo"></span>En Desarrollo' +
        '</div>' +
        '<div class="status-menu-item" data-status="completada">' +
        '<span class="status-dot completada"></span>Completada' +
        '</div>' +
        '<div class="status-menu-item" data-status="urgente">' +
        '<span class="status-dot urgente"></span>Urgente' +
        '</div>';

    const rect = buttonElement.getBoundingClientRect();
    menu.style.position = 'fixed';
    menu.style.top = (rect.bottom + 5) + 'px';
    menu.style.left = (rect.left - 80) + 'px';

    document.body.appendChild(menu);

    menu.addEventListener('click', function(e) {
            console.log('🖱️ Click en el menú detectado', e.target);
        const item = e.target.closest('.status-menu-item');
        if (!item) {
                        console.log('❌ Click fuera de un item del menú');
            return;
        }

        const newStatus = item.dataset.status;
            console.log('📋 Nuevo estado seleccionado:', newStatus, 'para solicitud:', requestId);
        changeRequestStatus(requestId, newStatus);
        menu.remove();
    });

    setTimeout(function() {
        document.addEventListener('click', function closeMenu(e) {
            if (!menu.contains(e.target) && e.target !== buttonElement) {
                menu.remove();
                document.removeEventListener('click', closeMenu);
            }
        });
    }, 100);
}

function changeRequestStatus(requestId, newStatus) {
    const index = allRequests.findIndex(function(r) { return r.id === requestId; });
    if (index === -1) {
        console.log('❌ No se encontró la solicitud con ID:', requestId);
        return;
    }

    console.log('🔄 Cambiando estado de', requestId, 'de', allRequests[index].status, 'a', newStatus);
    
    allRequests[index].status = newStatus;
    localStorage.setItem(REQUESTS_STORAGE_KEY, JSON.stringify(allRequests));

    applyFilters();
    renderStats();

    if (selectedRequestId === requestId && !document.getElementById('taskEditorForm').classList.contains('is-hidden')) {
        document.getElementById('editStatus').value = newStatus;
        const modeLabel = document.getElementById('editorModeLabel');
        modeLabel.textContent = getStatusLabel(newStatus);
        modeLabel.className = 'request-status ' + newStatus;
        console.log('✅ Badge actualizado en el editor');
    }
    
    console.log('✅ Estado cambiado exitosamente');
}
