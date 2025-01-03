const btnContinueRegister = document.getElementById("btn-continue-signup");
const firstPage = document.getElementById("first-page-signup");
const secondPage = document.getElementById("second-page-signup");

document.addEventListener("DOMContentLoaded", function () {
    firstPage.style.display = "block";
    secondPage.style.display = "none";
});

btnContinueRegister.addEventListener("click", function (e) {
    e.preventDefault();

    firstPage.style.display = "none";
    secondPage.style.display = "block";
});
