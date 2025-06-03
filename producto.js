document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById("loginForm");
    const errorMessage = document.getElementById("error-message");
    const loginSection = document.getElementById("login-section");
    const productSection = document.getElementById("product-section");
    const logoutSection = document.getElementById("logout-section");
    const logoutButton = document.getElementById("logout-button");
    const buyButtons = document.querySelectorAll(".buy-button");
    const loginWarning = document.getElementById("login-warning");

    let isLoggedIn = false;

    // Lógica para el inicio de sesión
    loginForm.addEventListener("submit", function (event) {
        event.preventDefault();

        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;

        if (username === "admin" && password === "admin123") {
            window.location.href = "dashboard.html";
        } else if (username === "cliente" && password === "cliente123") {
            loginSection.style.display = "none";
            logoutSection.style.display = "block";
            isLoggedIn = true;
            loginWarning.style.display = "none";  // Oculta el mensaje de advertencia

            // Habilita los botones de compra
            buyButtons.forEach(button => button.disabled = false);
        } else {
            errorMessage.style.display = "block";
            errorMessage.innerText = "Credenciales incorrectas. Por favor, inténtelo de nuevo.";
        }
    });

    // Lógica para el cierre de sesión
    logoutButton.addEventListener("click", function () {
        loginSection.style.display = "block";
        logoutSection.style.display = "none";
        isLoggedIn = false;

        // Deshabilita los botones de compra al cerrar sesión
        buyButtons.forEach(button => button.disabled = true);
    });

    // Lógica para el botón de compra
    buyButtons.forEach(button => {
        button.addEventListener("click", function () {
            if (isLoggedIn) {
                const productId = this.getAttribute("data-product-id");
                alert(`Producto ${productId} añadido al carrito.`);
            } else {
                // Muestra el mensaje de advertencia si el usuario no ha iniciado sesión
                loginWarning.style.display = "block";
            }
        });
    });

    // Lógica para el buscador de productos
    const searchButton = document.getElementById("search-button");
    const searchInput = document.getElementById("search-input");
    const products = document.querySelectorAll(".product");

    searchButton.addEventListener("click", function () {
        const searchTerm = searchInput.value.toLowerCase();

        products.forEach(product => {
            const productName = product.querySelector("h3").textContent.toLowerCase();
            if (productName.includes(searchTerm)) {
                product.style.display = "block";
            } else {
                product.style.display = "none";
            }
        });
    });
});
