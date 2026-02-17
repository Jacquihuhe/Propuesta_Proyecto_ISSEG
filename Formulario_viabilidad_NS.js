document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('formViabilidad');
    const checkVarias = document.getElementById('check-varias');
    const submenu = document.getElementById('submenu-areas');
    
    // Mostrar campo de sistema similar
    const selectSimilares = document.getElementById('sistemas-similares');
    if (selectSimilares) {
        selectSimilares.addEventListener('change', function() {
            const detalle = document.getElementById('detalle-similar');
            if (detalle) {
                detalle.style.display = this.value === 'si' ? 'block' : 'none';
            }
        });
    }

    // Mostrar/Ocultar submenú cuando se marca "Varias áreas"
    if (checkVarias && submenu) {
        checkVarias.addEventListener('change', function() {
            if (this.checked) {
                submenu.style.display = 'block';
                submenu.classList.remove('submenu-error');
            } else {
                submenu.style.display = 'none';
                const subCheckboxes = submenu.querySelectorAll('input[name="detalles_areas"]');
                subCheckboxes.forEach(cb => cb.checked = false);
            }
        });
    }

    // Lógica de exclusividad (Si marca "Todas", desmarcar el resto)
    const checkTodasLasAreas = document.querySelector('input[name="areas"][value="todas"]');
    if (checkTodasLasAreas) {
        checkTodasLasAreas.addEventListener('change', function() {
            if (this.checked) {
                const todosLosChecksPrincipales = document.querySelectorAll('input[name="areas"]');
                todosLosChecksPrincipales.forEach(cb => {
                    if (cb.value !== 'todas') cb.checked = false;
                });
                if (submenu) {
                    submenu.style.display = 'none';
                    const subCheckboxes = submenu.querySelectorAll('input[name="detalles_areas"]');
                    subCheckboxes.forEach(cb => cb.checked = false);
                }
            }
        });
    }

    // Validación y envío
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const checkboxesPrincipales = document.querySelectorAll('input[name="areas"]:checked');
            
            if (checkboxesPrincipales.length === 0) {
                alert('Por favor seleccione qué áreas se beneficiarán del sistema.');
                return;
            }

            if (checkVarias && checkVarias.checked && submenu) {
                const subCheckboxes = submenu.querySelectorAll('input[name="detalles_areas"]');
                const algunaSubArea = Array.from(subCheckboxes).some(cb => cb.checked);
                if (!algunaSubArea) {
                    submenu.classList.add('submenu-error');
                    alert('Has indicado "Varias áreas", por favor selecciona cuáles en el submenú.');
                    submenu.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return;
                }
            }
            
            if (confirm('¿Está seguro de enviar esta propuesta?')) {
                alert('Propuesta enviada exitosamente.\n\nRecibirá una notificación por correo.');
                // Aquí podrías usar form.submit() si ya tienes un backend listo
            }
        });
    }

    // Preview de archivos
    const inputFiles = document.getElementById('documentos-apoyo');
    if (inputFiles) {
        inputFiles.addEventListener('change', function() {
            const files = this.files;
            if (files.length > 0) {
                const label = this.nextElementSibling;
                label.querySelector('p').textContent = `${files.length} archivo(s) seleccionado(s)`;
                label.style.borderColor = '#28a745';
                label.style.backgroundColor = '#d4edda';
            }
        });
    }
});
