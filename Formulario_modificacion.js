document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formModificacion');
    
    // Manejo del envío del formulario
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const tipo = document.querySelector('input[name="tipo"]:checked');
            const prioridad = document.querySelector('input[name="prioridad"]:checked');
            
            if (!tipo) {
                alert('Por favor seleccione el tipo de solicitud');
                return;
            }
            
            if (!prioridad) {
                alert('Por favor seleccione la prioridad');
                return;
            }
            
            if (confirm('¿Está seguro de enviar esta solicitud de modificación?')) {
                alert('Solicitud enviada exitosamente.\n\nFolio asignado: MOD-' + new Date().getTime().toString().slice(-6) + '\n\nSe ha notificado al Product Manager para su validación.');
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
                label.querySelector('small').textContent = Array.from(files).map(f => f.name).join(', ');
                label.style.borderColor = '#28a745';
                label.style.backgroundColor = '#d4edda';
            }
        });
    }
});
