const API_BASE_URL = localStorage.getItem('apiBaseUrl') || 'http://localhost:5214';

function resolveRoleFromRoles(roles) {
    const normalized = Array.isArray(roles)
        ? roles.map(r => String(r).trim().toLowerCase())
        : [];

    if (normalized.includes('product_manager') || normalized.includes('admin')) {
        return { role: 'product_manager', redirect: 'home_pm.html' };
    }

    if (normalized.includes('developer')) {
        return { role: 'developer', redirect: 'home_developer.html' };
    }

    return { role: 'user', redirect: 'home_cliente.html' };
}

document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const togglePassword = document.getElementById('togglePassword');
    const rememberMe = document.getElementById('rememberMe');
    const alertMessage = document.getElementById('alertMessage');

    // Toggle password visibility
    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            // Cambiar icono
            const icon = type === 'password' 
                ? `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                   </svg>`
                : `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                   </svg>`;
            
            this.innerHTML = icon;
        });
    }

    // Verificar si hay usuario guardado
    const savedUsername = localStorage.getItem('rememberedUser');
    if (savedUsername) {
        usernameInput.value = savedUsername;
        rememberMe.checked = true;
    }

    // Manejar envío del formulario
    loginForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const username = usernameInput.value.trim();
        const password = passwordInput.value;

        try {
            const response = await fetch(`${API_BASE_URL}/api/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    correoElectronico: username,
                    contrasena: password
                })
            });

            if (!response.ok) {
                throw new Error('Credenciales inválidas. Por favor, verifica tu usuario y contraseña.');
            }

            const data = await response.json();
            const roleData = resolveRoleFromRoles(data.roles);

            showAlert('success', 'Acceso autorizado. Redirigiendo al sistema...');

            if (rememberMe.checked) {
                localStorage.setItem('rememberedUser', username);
            } else {
                localStorage.removeItem('rememberedUser');
            }

            sessionStorage.setItem('currentUser', JSON.stringify({
                userId: data.usuarioId,
                username: data.correoElectronico,
                role: roleData.role,
                roles: Array.isArray(data.roles) ? data.roles : [],
                name: data.nombreCompleto || data.correoElectronico,
                loginTime: new Date().toISOString()
            }));

            const btn = loginForm.querySelector('.btn-login');
            btn.innerHTML = `
                <svg class="spinner" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10" opacity="0.25"/>
                    <path d="M12 2 A10 10 0 0 1 22 12" opacity="1">
                        <animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="1s" repeatCount="indefinite"/>
                    </path>
                </svg>
                <span>Accediendo...</span>
            `;
            btn.style.pointerEvents = 'none';

            setTimeout(() => {
                window.location.href = roleData.redirect;
            }, 1200);
        } catch (error) {
            showAlert('error', error.message || 'No fue posible conectar con la API.');

            passwordInput.value = '';
            usernameInput.style.animation = 'shake 0.5s';
            passwordInput.style.animation = 'shake 0.5s';

            setTimeout(() => {
                usernameInput.style.animation = '';
                passwordInput.style.animation = '';
                passwordInput.focus();
            }, 500);
        }
    });

    // Función para mostrar alertas
    function showAlert(type, message) {
        alertMessage.className = `alert-message ${type}`;
        
        const icon = type === 'success' 
            ? `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="20 6 9 17 4 12"/>
               </svg>`
            : `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8" x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
               </svg>`;
        
        alertMessage.innerHTML = `${icon}<span>${message}</span>`;
        alertMessage.style.display = 'flex';

        // Ocultar después de 5 segundos si es error
        if (type === 'error') {
            setTimeout(() => {
                alertMessage.style.display = 'none';
            }, 5000);
        }
    }

    // Animación de shake para errores
    const style = document.createElement('style');
    style.textContent = `
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
    `;
    document.head.appendChild(style);

    // Focus automático en el campo de usuario
    usernameInput.focus();

    // Prevenir clic en "Olvidaste tu contraseña"
    document.querySelector('.forgot-password').addEventListener('click', function(e) {
        e.preventDefault();
        showAlert('error', 'Para recuperar tu contraseña, contacta al área de Sistemas Institucionales.');
    });
});
