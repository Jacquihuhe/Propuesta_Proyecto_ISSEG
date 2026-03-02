document.addEventListener('DOMContentLoaded', function() {
    // Verificar si hay sesión activa
    const currentUser = sessionStorage.getItem('currentUser');
    
    if (!currentUser) {
        window.location.href = 'login.html';
        return;
    }

    const userData = JSON.parse(currentUser);
    
    // Datos de perfil de ejemplo (en producción vendrían del servidor)
    const profileData = {
        firstName: 'Juan Carlos',
        lastName: 'García Hernández',
        email: userData.username,
        phone: '(473) 123-4567',
        extension: '1234',
        employeeId: 'EMP-2024-0123',
        department: getDepartmentByRole(userData.role),
        position: getPositionByRole(userData.role)
    };

    // Cargar datos en el perfil
    loadProfileData(profileData);

    // Manejar función de regresar
    window.goBack = function() {
        if (userData.role === 'user') {
            window.location.href = 'home_cliente.html';
        } else if (userData.role === 'developer') {
            window.location.href = 'home_developer.html';
        } else if (userData.role === 'product_manager') {
            window.location.href = 'home_pm.html';
        } else {
            window.location.href = 'login.html';
        }
    };

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

    // Manejar edición de perfil
    const btnEdit = document.getElementById('btnEdit');
    const btnCancel = document.getElementById('btnCancel');
    const profileForm = document.getElementById('profileForm');
    const formActions = document.querySelector('.form-actions');

    btnEdit.addEventListener('click', function() {
        enableEditing();
    });

    btnCancel.addEventListener('click', function() {
        disableEditing();
        loadProfileData(profileData); // Restaurar datos originales
    });

    profileForm.addEventListener('submit', function(e) {
        e.preventDefault();
        saveProfile();
    });

    // Manejar cambio de contraseña
    window.changePassword = function() {
        const newPassword = prompt('Ingresa tu nueva contraseña:');
        if (newPassword) {
            const confirmPassword = prompt('Confirma tu nueva contraseña:');
            if (newPassword === confirmPassword) {
                alert('✅ Contraseña actualizada correctamente');
            } else {
                alert('❌ Las contraseñas no coinciden');
            }
        }
    };

    // Manejar vista de sesiones
    window.viewSessions = function() {
        alert('Sesiones Activas:\n\n1. Navegador actual (Windows 11)\n   Última actividad: Ahora\n   IP: 192.168.1.100');
    };

    // Manejar toggles de preferencias
    const emailNotifications = document.getElementById('emailNotifications');
    const pushNotifications = document.getElementById('pushNotifications');
    const darkMode = document.getElementById('darkMode');

    emailNotifications.addEventListener('change', function() {
        savePreference('emailNotifications', this.checked);
    });

    pushNotifications.addEventListener('change', function() {
        savePreference('pushNotifications', this.checked);
    });

    darkMode.addEventListener('change', function() {
        savePreference('darkMode', this.checked);
        if (this.checked) {
            alert('💡 El modo oscuro se implementará en una futura actualización');
        }
    });
});

function loadProfileData(data) {
    // Header
    document.getElementById('userName').textContent = `${data.firstName} ${data.lastName}`;
    document.getElementById('userRole').textContent = data.position;
    
    // Profile summary
    document.getElementById('profileName').textContent = `${data.firstName} ${data.lastName}`;
    document.getElementById('profileEmail').textContent = data.email;
    document.getElementById('profilePosition').textContent = `${data.position} - ${data.department}`;
    
    // Form fields
    document.getElementById('firstName').value = data.firstName;
    document.getElementById('lastName').value = data.lastName;
    document.getElementById('email').value = data.email;
    document.getElementById('phone').value = data.phone;
    document.getElementById('extension').value = data.extension;
    document.getElementById('employeeId').value = data.employeeId;
    document.getElementById('department').value = data.department;
    document.getElementById('position').value = data.position;
}

function enableEditing() {
    const inputs = document.querySelectorAll('.profile-form input:not(#email):not(#employeeId)');
    inputs.forEach(input => {
        input.disabled = false;
        input.style.background = 'white';
    });
    
    document.querySelector('.form-actions').style.display = 'flex';
    document.getElementById('btnEdit').style.display = 'none';
}

function disableEditing() {
    const inputs = document.querySelectorAll('.profile-form input');
    inputs.forEach(input => {
        input.disabled = true;
        input.style.background = '';
    });
    
    document.querySelector('.form-actions').style.display = 'none';
    document.getElementById('btnEdit').style.display = 'flex';
}

function saveProfile() {
    // Obtener datos del formulario
    const formData = {
        firstName: document.getElementById('firstName').value,
        lastName: document.getElementById('lastName').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        extension: document.getElementById('extension').value,
        employeeId: document.getElementById('employeeId').value,
        department: document.getElementById('department').value,
        position: document.getElementById('position').value
    };
    
    // En producción, aquí se enviaría al servidor
    console.log('Guardando perfil:', formData);
    
    // Actualizar perfil summary
    document.getElementById('profileName').textContent = `${formData.firstName} ${formData.lastName}`;
    document.getElementById('profilePosition').textContent = `${formData.position} - ${formData.department}`;
    document.getElementById('userName').textContent = `${formData.firstName} ${formData.lastName}`;
    document.getElementById('userRole').textContent = formData.position;
    
    // Deshabilitar edición
    disableEditing();
    
    alert('✅ Perfil actualizado correctamente');
}

function savePreference(key, value) {
    // En producción, esto se guardaría en el servidor
    localStorage.setItem(key, value);
    console.log(`Preferencia guardada: ${key} = ${value}`);
}

function getDepartmentByRole(role) {
    const departments = {
        'user': 'Área Solicitante',
        'developer': 'Área de Sistemas',
        'product_manager': 'Dirección de Sistemas'
    };
    return departments[role] || 'No especificado';
}

function getPositionByRole(role) {
    const positions = {
        'user': 'Solicitante',
        'developer': 'Desarrollador',
        'product_manager': 'Product Manager'
    };
    return positions[role] || 'No especificado';
}
