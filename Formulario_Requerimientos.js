document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formRequerimientos');

    // Validación del formulario
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validar campos requeridos
            const camposRequeridos = this.querySelectorAll('[required]');
            let todosCompletos = true;
            
            camposRequeridos.forEach(campo => {
                if (!campo.value.trim()) {
                    todosCompletos = false;
                    campo.classList.add('error');
                } else {
                    campo.classList.remove('error');
                }
            });
            
            if (todosCompletos) {
                if (confirm('¿Está seguro de enviar este formulario a desarrollo? Una vez enviado, el equipo técnico comenzará a trabajar con esta información.')) {
                    alert('Formulario enviado exitosamente. Se ha generado el folio REQ-2024-00XXX y se ha notificado al Product Manager.');
                    // Aquí iría el código para enviar el formulario (no se te olvide)
                }
            } else {
                alert('Por favor complete todos los campos obligatorios marcados con *');
                // Scroll al primer campo con error
                const primerError = this.querySelector('.error');
                if (primerError) {
                    primerError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    }

    // Preview de archivos subidos
    const uploadAreas = document.querySelectorAll('.upload-area input[type="file"]');
    uploadAreas.forEach(input => {
        input.addEventListener('change', function() {
            const files = this.files;
            if (files.length > 0) {
                const label = this.nextElementSibling;
                let fileNames = '';
                for (let i = 0; i < files.length; i++) {
                    fileNames += files[i].name + (i < files.length - 1 ? ', ' : '');
                }
                label.querySelector('p').textContent = `${files.length} archivo(s) seleccionado(s)`;
                label.querySelector('small').textContent = fileNames;
                label.style.borderColor = '#28a745';
                label.style.backgroundColor = '#d4edda';
            }
        });
    });
});

// Función para guardar borrador (simulada)
function guardarBorrador() {
    alert('Borrador guardado exitosamente. Podrá continuar más tarde.');
}

// Función para previsualizar (simulada)
function previsualizarFormulario() {
    alert('Función de previsualización: Aquí se mostraría un resumen de todos los campos completados.');
}
