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
        btnLogout.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('¿Estás seguro que deseas cerrar sesión?')) {
                sessionStorage.removeItem('currentUser');
                window.location.href = 'login.html';
            }
        });
    }

    // Manejar dropdown de perfil
    const userProfileBtn = document.getElementById('userProfileBtn');
    const userDropdownMenu = document.getElementById('userDropdownMenu');

    if (userProfileBtn && userDropdownMenu) {
        userProfileBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdownMenu.classList.toggle('show');
            userProfileBtn.classList.toggle('active');
        });

        // Cerrar dropdown al hacer click fuera
        document.addEventListener('click', function(e) {
            if (!userProfileBtn.contains(e.target) && !userDropdownMenu.contains(e.target)) {
                userDropdownMenu.classList.remove('show');
                userProfileBtn.classList.remove('active');
            }
        });
    }
});

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

// ========== FUNCIONES PARA CONFIGURACIÓN ==========
function saveConfiguration() {
    const emailNotif = document.getElementById('emailNotifications')?.checked;
    const browserNotif = document.getElementById('browserNotifications')?.checked;
    const dailySummary = document.getElementById('dailySummary')?.checked;
    const notifSound = document.getElementById('notificationSound')?.checked;
    const language = document.getElementById('language')?.value;
    const timezone = document.getElementById('timezone')?.value;
    const dateFormat = document.getElementById('dateFormat')?.value;
    const twoFactor = document.getElementById('twoFactorAuth')?.checked;
    const autoLogout = document.getElementById('autoLogout')?.checked;
    const theme = document.getElementById('theme')?.value;
    const density = document.getElementById('density')?.value;
    const animations = document.getElementById('animations')?.checked;

    const config = {
        emailNotifications: emailNotif,
        browserNotifications: browserNotif,
        dailySummary: dailySummary,
        notificationSound: notifSound,
        language: language,
        timezone: timezone,
        dateFormat: dateFormat,
        twoFactorAuth: twoFactor,
        autoLogout: autoLogout,
        theme: theme,
        density: density,
        animations: animations
    };

    // Guardar en localStorage
    localStorage.setItem('userConfiguration', JSON.stringify(config));
    
    console.log('Configuración guardada:', config);
    alert('✅ Configuración guardada exitosamente');
}

// ========== FUNCIONES PARA CAMBIO DE CONTRASEÑA ==========
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const button = field.parentElement.querySelector('.toggle-password');
    
    if (field.type === 'password') {
        field.type = 'text';
        button.innerHTML = `
            <svg class="eye-off-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path>
            </svg>
        `;
    } else {
        field.type = 'password';
        button.innerHTML = `
            <svg class="eye-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
            </svg>
        `;
    }
}

function checkPasswordStrength(password) {
    let strength = 0;
    const strengthBar = document.querySelector('.strength-fill');
    const strengthText = document.querySelector('.strength-text');
    
    // Criterios de fortaleza
    if (password.length >= 8) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;
    
    // Actualizar barra
    const percentage = (strength / 5) * 100;
    strengthBar.style.width = percentage + '%';
    
    // Actualizar clase y texto
    strengthBar.className = 'strength-fill';
    if (strength <= 2) {
        strengthBar.classList.add('weak');
        strengthText.textContent = 'Débil';
    } else if (strength <= 4) {
        strengthBar.classList.add('medium');
        strengthText.textContent = 'Media';
    } else {
        strengthBar.classList.add('strong');
        strengthText.textContent = 'Fuerte';
    }
}

function checkPasswordMatch() {
    const newPassword = document.getElementById('newPassword')?.value;
    const confirmPassword = document.getElementById('confirmPassword')?.value;
    const matchIndicator = document.querySelector('.password-match');
    
    if (confirmPassword.length === 0) {
        matchIndicator.textContent = '';
        matchIndicator.className = 'password-match';
        return;
    }
    
    if (newPassword === confirmPassword) {
        matchIndicator.textContent = '✓ Las contraseñas coinciden';
        matchIndicator.className = 'password-match match';
    } else {
        matchIndicator.textContent = '✗ Las contraseñas no coinciden';
        matchIndicator.className = 'password-match no-match';
    }
}

function submitPasswordChange(event) {
    event.preventDefault();
    
    const currentPassword = document.getElementById('currentPassword')?.value;
    const newPassword = document.getElementById('newPassword')?.value;
    const confirmPassword = document.getElementById('confirmPassword')?.value;
    
    // Validaciones
    if (!currentPassword || !newPassword || !confirmPassword) {
        alert('❌ Por favor completa todos los campos');
        return;
    }
    
    if (newPassword !== confirmPassword) {
        alert('❌ Las contraseñas nuevas no coinciden');
        return;
    }
    
    if (newPassword.length < 8) {
        alert('❌ La contraseña debe tener al menos 8 caracteres');
        return;
    }
    
    // Simular cambio de contraseña (en producción se enviaría al servidor)
    console.log('Cambiando contraseña...');
    
    // Limpiar campos
    document.getElementById('passwordForm').reset();
    document.querySelector('.strength-fill').style.width = '0';
    document.querySelector('.password-match').textContent = '';
    
    alert('✅ Contraseña actualizada correctamente');
}

// ========== FUNCIONES PARA PREFERENCIAS ==========
function clearCache() {
    if (confirm('¿Estás seguro de que deseas borrar el caché? Esta acción no se puede deshacer.')) {
        localStorage.removeItem('formData');
        localStorage.removeItem('cachedRequests');
        console.log('Caché borrado');
        alert('✅ Caché borrado exitosamente');
    }
}

function savePreferences() {
    const defaultView = document.getElementById('defaultView')?.value;
    const itemsPerPage = document.getElementById('itemsPerPage')?.value;
    const confirmSubmit = document.getElementById('confirmSubmit')?.checked;
    const autoSave = document.getElementById('autoSave')?.checked;
    
    const statusUpdates = document.getElementById('statusUpdates')?.checked;
    const commentNotifs = document.getElementById('commentNotifications')?.checked;
    const assignmentNotifs = document.getElementById('assignmentNotifications')?.checked;
    const reminders = document.getElementById('reminders')?.checked;
    const newsletter = document.getElementById('newsletter')?.checked;
    
    const showStats = document.getElementById('showStats')?.checked;
    const showRecent = document.getElementById('showRecent')?.checked;
    const showAssistant = document.getElementById('showAssistant')?.checked;
    const showTips = document.getElementById('showTips')?.checked;
    
    const rememberForms = document.getElementById('rememberForms')?.checked;
    const rememberSession = document.getElementById('rememberSession')?.checked;

    const preferences = {
        workflow: { defaultView, itemsPerPage, confirmSubmit, autoSave },
        email: { statusUpdates, commentNotifs, assignmentNotifs, reminders, newsletter },
        dashboard: { showStats, showRecent, showAssistant, showTips },
        data: { rememberForms, rememberSession }
    };

    localStorage.setItem('userPreferences', JSON.stringify(preferences));
    console.log('Preferencias guardadas:', preferences);
    alert('✅ Preferencias guardadas exitosamente');
}

// ========== FUNCIONES PARA ACCESIBILIDAD ==========
function resetAccessibility() {
    if (confirm('¿Restablecer todas las opciones de accesibilidad a sus valores predeterminados?')) {
        // Restablecer todos los controles a valores por defecto
        document.getElementById('fontSize')?.value = 'normal';
        document.getElementById('lineHeight')?.value = 'normal';
        document.getElementById('highContrast')?.checked = false;
        document.getElementById('underlineLinks')?.checked = false;
        document.getElementById('sansSerif')?.checked = false;
        
        document.getElementById('reduceMotion')?.checked = false;
        document.getElementById('disableAutoplay')?.checked = false;
        document.getElementById('pauseOnFocus')?.checked = false;
        
        document.getElementById('focusHighlight')?.checked = true;
        document.getElementById('keyboardShortcuts')?.checked = true;
        document.getElementById('skipToContent')?.checked = true;
        
        document.getElementById('screenReaderMode')?.checked = false;
        document.getElementById('ariaLive')?.checked = true;
        document.getElementById('extendedDescriptions')?.checked = false;
        
        document.getElementById('colorFilter')?.value = 'none';
        document.getElementById('usePatterns')?.checked = false;
        
        localStorage.removeItem('accessibilitySettings');
        alert('✅ Configuración de accesibilidad restablecida');
    }
}

function saveAccessibilitySettings() {
    const settings = {
        fontSize: document.getElementById('fontSize')?.value,
        lineHeight: document.getElementById('lineHeight')?.value,
        highContrast: document.getElementById('highContrast')?.checked,
        underlineLinks: document.getElementById('underlineLinks')?.checked,
        sansSerif: document.getElementById('sansSerif')?.checked,
        reduceMotion: document.getElementById('reduceMotion')?.checked,
        disableAutoplay: document.getElementById('disableAutoplay')?.checked,
        pauseOnFocus: document.getElementById('pauseOnFocus')?.checked,
        focusHighlight: document.getElementById('focusHighlight')?.checked,
        keyboardShortcuts: document.getElementById('keyboardShortcuts')?.checked,
        skipToContent: document.getElementById('skipToContent')?.checked,
        screenReaderMode: document.getElementById('screenReaderMode')?.checked,
        ariaLive: document.getElementById('ariaLive')?.checked,
        extendedDescriptions: document.getElementById('extendedDescriptions')?.checked,
        colorFilter: document.getElementById('colorFilter')?.value,
        usePatterns: document.getElementById('usePatterns')?.checked
    };

    localStorage.setItem('accessibilitySettings', JSON.stringify(settings));
    console.log('Configuración de accesibilidad guardada:', settings);
    alert('✅ Configuración de accesibilidad guardada exitosamente');
}

// ========== FUNCIONES PARA CERTIFICADOS ==========
function addCertificate() {
    alert('📋 Función para agregar nuevo certificado\n\nEsta funcionalidad permitirá cargar:\n- Nombre del certificado\n- Institución emisora\n- Fecha de emisión\n- Fecha de vencimiento\n- Archivo PDF del certificado');
}

function viewCertificate(certName) {
    alert(`👁️ Visualizando certificado: ${certName}`);
}

function downloadCertificate(certName) {
    alert(`⬇️ Descargando certificado: ${certName}`);
}

function shareCertificate(certName) {
    alert(`🔗 Compartiendo certificado: ${certName}\n\nSe generará un enlace seguro para compartir.`);
}

function verifyCertificate(certName) {
    alert(`✓ Verificando certificado: ${certName}\n\nVerificación exitosa.`);
}

function renewCertificate(certName) {
    alert(`🔄 Renovando certificado: ${certName}\n\nRedirigiendo al proceso de renovación...`);
}
