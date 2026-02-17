document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formUrgente');
    
    // Manejo del envío del formulario
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const impacto = document.querySelector('input[name="impacto"]:checked');
            
            if (!impacto) {
                alert('Por favor seleccione el nivel de impacto');
                return;
            }
            
            if (confirm('¿Está seguro de enviar este reporte de falla urgente? Se notificará inmediatamente al Product Manager.')) {
                alert('Reporte enviado exitosamente. Folio asignado: URG-' + new Date().getTime().toString().slice(-6) + '\n\nSe ha notificado al equipo de desarrollo y recibirá actualizaciones por correo.');
                // Aquí va la lógica de envío (de mi para mí, solo simulo el envío)
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
                label.style.borderColor = '#d93025';
                label.style.backgroundColor = '#fff5f5';
            }
        });
    }
});
