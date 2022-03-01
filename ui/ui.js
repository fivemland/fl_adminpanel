const joinTime = Date.now();
const playTimeElement = document.getElementById("playTime");

setInterval(() => {
  const timeDiff = new Date(Date.now() - joinTime);

  const hours = timeDiff.getHours() - 1;
  const minutes = timeDiff.getMinutes();
  const seconds = timeDiff.getSeconds();

  playTimeElement.innerText = `${hours < 10 ? "0" + hours : hours}:${
    minutes < 10 ? "0" + minutes : minutes
  }:${seconds < 10 ? "0" + seconds : seconds}`;
}, 1000);

window.addEventListener("message", (event) => {
  let data = event.data;

  if (data.action == "showUI") {
    const showUI = document.querySelector(".content");
    showUI.style.display = "block";
  }

  if (data.action == "hideUI") {
    const hideUI = document.querySelector(".content");
    hideUI.style.display = "none";
  }

  if (data.group != undefined) {
    document.getElementById("group").innerHTML = data.group;
  }

  if (data.action == "alert") {
    toastAnotherAlert(data.msg, data.title, data.color);
  }

  if (data.playerCount != undefined) {
    document.getElementById("players").innerHTML = data.playerCount;
  }

  let AdminCommands = data.AdminCommands;
  if (AdminCommands) {
    document.getElementById("commands").innerHTML = "";

    var newTable = "<table  width='100%' >";
    for (let i = 0; i < AdminCommands.length; i++) {
      newTable +=
        "<tr><th>" +
        AdminCommands[i].name +
        "</th><th>" +
        AdminCommands[i].description +
        "</th></tr>";
    }
    newTable += "</table>";

    document.getElementById("commands").innerHTML = newTable;
  }
});

function Godmode() {
  fetch(`https://${GetParentResourceName()}/Godmode`);
}

function Speedrun() {
  fetch(`https://${GetParentResourceName()}/Speedrun`);
}

function SuperJump() {
  fetch(`https://${GetParentResourceName()}/SuperJump`);
}

function Invisible() {
  fetch(`https://${GetParentResourceName()}/Invisible`);
}

function logKey(e) {
  if (e.key == "Escape") {
    fetch(`https://${GetParentResourceName()}/close`);
  }
}

let onduty = false;
function Duty() {
  const dbutton = document.getElementById("dbutton");
  const dtext = document.getElementById("dtext");

  if (onduty) {
    onduty = false;
    fetch(`https://${GetParentResourceName()}/Duty`);
    dbutton.classList.remove("btn-success");
    dbutton.classList.remove("btn-danger");
    dbutton.classList.add("btn-success");
    dtext.innerHTML = " Belépés a szolgálatba";
  } else {
    onduty = true;
    fetch(`https://${GetParentResourceName()}/Duty`);
    dbutton.classList.remove("btn-success");
    dbutton.classList.remove("btn-danger");
    dbutton.classList.add("btn-danger");
    dtext.innerHTML = " Kilépés a szolgálatból";
  }
}

function closePanel() {
  fetch(`https://${GetParentResourceName()}/close`);
}

document.addEventListener("keydown", logKey);

$(function () {
  $(".content").draggable();
});

function toastAnotherAlert(msg, title, color) {
  halfmoon.initStickyAlert({
    content: msg,
    title: title,
    alertType: "alert-" + color,
    fillType: "filled",
    hasDismissButton: true,
    timeShown: msg.length * 250,
  });
}

async function CopyCoords() {
  const response = await fetch(`https://${GetParentResourceName()}/CopyCoords`);

  const { position } = await response.json();

  const inputElement = document.querySelector(".clipboard");
  inputElement.value = position;
  inputElement.select();
  inputElement.setSelectionRange(0, position.length);
  document.execCommand("copy");

  inputElement.value = "";
  toastAnotherAlert("Vágólapra másolva!", "Koordináta", "primary");
}
