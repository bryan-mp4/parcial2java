// Utilidades mínimas del front (sin frameworks ni CDN).
(function () {
    "use strict";

    // Cierra automáticamente las alertas de éxito después de 6 segundos.
    document.querySelectorAll(".alerta--exito").forEach(function (alerta) {
        window.setTimeout(function () {
            alerta.style.display = "none";
        }, 6000);
    });

    // Confirmación genérica para acciones delicadas (eliminar, desactivar).
    document.querySelectorAll("form[data-confirmar]").forEach(function (form) {
        form.addEventListener("submit", function (evento) {
            if (!window.confirm(form.getAttribute("data-confirmar"))) {
                evento.preventDefault();
            }
        });
    });
})();
