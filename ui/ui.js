window.addEventListener('message', (event) => {
    let data = event.data

    if (data.action == 'showUI') {
        const showUI = document.querySelector('.content')
        showUI.style.display = 'block'
    }

    if (data.action == 'hideUI') {
        const hideUI = document.querySelector('.content')
        hideUI.style.display = 'none'
    }

    if (data.group != undefined) {
        document.getElementById("group").innerHTML = data.group;
    }

    if (data.action == 'alert') {
        toastAnotherAlert(data.msg, data.title, data.color)
    }

    if (data.playerCount != undefined) {
        document.getElementById("players").innerHTML = data.playerCount;
    }
    
    
})

function godmode() {
    fetch('https://adam_adminpanel/godmode')
}

function speedrun() {
    fetch('https://adam_adminpanel/speedrun')
}

function superjump() {
    fetch('https://adam_adminpanel/superjump')
}

function invisible() {
    fetch('https://adam_adminpanel/invisible')
}

function logKey(e) {
    if (e.key == 'Escape') {
        
        fetch('https://adam_adminpanel/close')

    }
}

function closePanel() {
    console.log("test")
    fetch('https://adam_adminpanel/close');
}

document.addEventListener('keydown', logKey);
 
$(function() {
    $( ".content" ).draggable();
});

function toastAnotherAlert(msg, title, color) {
    halfmoon.initStickyAlert({
        content: msg,      
        title: title,
        alertType: "alert-" + color,
        fillType: "filled",
        hasDismissButton: false,
        timeShown: msg.length * 250
    })
}

async function savecoords() {
    const response = await fetch('https://adam_adminpanel/copycoords')

    const {position} = await response.json()

    const inputElement = document.querySelector('.clipboard')
    inputElement.value = position
    inputElement.select()
    inputElement.setSelectionRange(0, position.length)
    document.execCommand('copy')

    inputElement.value = ''
}

setInterval(() => {   
    const date = new Date()
    document.getElementById("time").innerHTML = ("0" + date.getHours()).slice(-2)+":"+("0" + date.getMinutes()).slice(-2);
}, 1000);

