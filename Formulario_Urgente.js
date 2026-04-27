const API_BASE_URL = localStorage.getItem('apiBaseUrl') || 'http://localhost:5214';

function mapImpactoToPrioridadId(impactoValue) {
    switch ((impactoValue || '').toLowerCase()) {
        case 'critico':
            return 4;
        case 'alto':
            return 3;
        case 'medio':
            return 2;
        case 'bajo':
        default:
            return 1;
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formUrgente');
    const isPreviewMode = new URLSearchParams(window.location.search).get('preview') === '1';

    if (isPreviewMode) {
        return;
    }
    
    // ========== AUTO-RELLENAR DATOS DEL USUARIO ==========
    const currentUser = sessionStorage.getItem('currentUser');
    if (!currentUser) {
        alert('⚠️ Sesión no encontrada. Será redirigido al inicio de sesión.');
        window.location.href = 'login.html';
        return;
    }

    const userData = JSON.parse(currentUser);

    if (!userData.userId) {
        alert('⚠️ La sesión actual no tiene identificador de usuario. Inicie sesión nuevamente.');
        sessionStorage.removeItem('currentUser');
        window.location.href = 'login.html';
        return;
    }
    
    // Obtener datos del perfil desde localStorage (si existen) o usar valores por defecto
    const profileData = {
        firstName: localStorage.getItem('firstName') || userData.username.split('@')[0],
        lastName: localStorage.getItem('lastName') || '',
        department: localStorage.getItem('department') || 'Sistemas',
        position: localStorage.getItem('position') || 'Empleado',
        phone: localStorage.getItem('phone') || 'Ext. 1234',
        email: userData.username
    };

    // Rellenar campos ocultos para enviar (información interna, no visible)
    const nombreSolicitante = document.getElementById('nombre-solicitante');
    const apellidoPaternoSolicitante = document.getElementById('apellido-paterno-solicitante');
    const apellidoMaternoSolicitante = document.getElementById('apellido-materno-solicitante');
    const areaSolicitante = document.getElementById('area-solicitante');
    const telefono = document.getElementById('telefono');
    const correo = document.getElementById('correo');

    if (nombreSolicitante) nombreSolicitante.value = profileData.firstName;
    if (apellidoPaternoSolicitante) apellidoPaternoSolicitante.value = profileData.lastName;
    if (apellidoMaternoSolicitante) apellidoMaternoSolicitante.value = '';
    if (areaSolicitante) areaSolicitante.value = profileData.department.toLowerCase();
    if (telefono) telefono.value = profileData.phone;
    if (correo) correo.value = profileData.email;
    
    // ========== MANEJO DEL FORMULARIO ==========
    // Manejo del envío del formulario
    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const impacto = document.querySelector('input[name="impacto"]:checked');
            
            if (!impacto) {
                alert('Por favor seleccione el nivel de impacto');
                return;
            }
            
            if (confirm('¿Está seguro de enviar este reporte de falla urgente? Se notificará inmediatamente al Product Manager.')) {
                const sistema = document.getElementById('sistema')?.value?.trim() || 'Sistema no especificado';
                const descripcionFalla = document.getElementById('descripcion-falla')?.value?.trim() || '';
                const fechaFalla = document.getElementById('hora-falla')?.value?.trim() || '';
                const frecuencia = document.getElementById('frecuencia')?.value?.trim() || '';
                const usuariosAfectados = document.getElementById('usuarios-afectados')?.value?.trim() || '';
                const procesosBloqueados = document.getElementById('procesos-bloqueados')?.value?.trim() || '';
                const informacionAdicional = document.getElementById('informacion-adicional')?.value?.trim() || '';

                const descripcion = [
                    `Sistema: ${sistema}`,
                    `Descripcion de falla: ${descripcionFalla}`,
                    fechaFalla ? `Fecha detectada: ${fechaFalla}` : '',
                    frecuencia ? `Frecuencia: ${frecuencia}` : '',
                    usuariosAfectados ? `Usuarios afectados: ${usuariosAfectados}` : '',
                    procesosBloqueados ? `Procesos bloqueados: ${procesosBloqueados}` : '',
                    informacionAdicional ? `Informacion adicional: ${informacionAdicional}` : ''
                ].filter(Boolean).join('\n\n');

                try {
                    const response = await fetch(`${API_BASE_URL}/api/solicitudes`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            titulo: `Falla urgente - ${sistema}`,
                            descripcion,
                            areaSolicitanteId: 1,
                            sistemaId: null,
                            tipoSolicitudId: 4,
                            prioridadSolicitudId: mapImpactoToPrioridadId(impacto.value),
                            creadoPorUsuarioId: userData.userId,
                            fechaCompromiso: null
                        })
                    });

                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error(errorText || 'No se pudo registrar la solicitud urgente.');
                    }

                    const data = await response.json();
                    alert(`Reporte enviado exitosamente.\n\nFolio: ${data.folio}\nID: ${data.solicitudId}`);
                    form.reset();
                } catch (error) {
                    alert(error.message || 'Error de conexión con la API.');
                }
            }
        });
    }

    // Preview de archivos
    const evidenciasInput = document.getElementById('evidencias');
    if (evidenciasInput) {
        evidenciasInput.addEventListener('change', function() {
            const files = this.files;
            if (files.length > 0) {
                const label = this.nextElementSibling;
                label.querySelector('p').textContent = `${files.length} archivo(s) seleccionado(s)`;
                label.style.borderColor = '#FF3B30';
                label.style.backgroundColor = '#ffebea';
            }
        });
    }
});
