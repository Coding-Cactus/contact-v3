(() => {
    const selem = document.currentScript;

    const button = document.createElement("button");
    button.className = "replit-auth-button";
    button.textContent = "Login With Replit";

    if (location.protocol !== "https:") {
        const err = document.createElement("div");
        err.className = "replit-auth-error";
        err.textContent = "Replit auth requires https!";
        selem.parentNode.insertBefore(err, selem);
    }

    button.onclick = () => {
        window.addEventListener("message", authComplete);

        const h = 600;
        const w = 350;
        const left = screen.width / 2 - w / 2;
        const top = screen.height / 2 - h / 2;

        const authWindow = window.open(
            "https://repl.it/auth_with_repl_site?domain=" + location.host,
            "_blank",
            "modal =yes, toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=" +
            w +
            ", height=" +
            h +
            ", top=" +
            top +
            ", left=" +
            left,
        );

        function authComplete(e) {
            if (e.data !== "auth_complete") {
                return;
            }

            window.removeEventListener("message", authComplete);

            authWindow.close();
            if (selem.attributes.authed.value) {
                eval(selem.attributes.authed.value);
            } else {
                location.reload();
            }
        }
    };

    selem.parentNode.insertBefore(button, selem);
})();
