window.addEventListener("message", function (event) {
  const data = event.data;
  const body = document.body;

  if (data.action === "openTicketUI") {
    body.classList.remove("hidden");
    body.classList.add("active");
    document.getElementById("ticketUI").classList.remove("hidden");
    document.getElementById("reason").value = "";
  } else if (data.action === "openAdminUI") {

    body.classList.remove("hidden");
    body.classList.add("active");
    document.getElementById("adminUI").classList.remove("hidden");

    const existingBtn = document.getElementById("statsBtn");
    if (existingBtn) {
      existingBtn.remove();
    }

    if (data.showStatsButton === true) {


  const newBtn = document.createElement("button");
  newBtn.id = "statsBtn";
  newBtn.className = "admin-button";
  newBtn.innerText = "Ticket Statistics";
  newBtn.onclick = requestStats;

  document.getElementById("adminUI").appendChild(newBtn);

      const closeBtn = document.querySelector('#adminUI button[onclick="closeUI()"]');
      if (closeBtn) {
        closeBtn.insertAdjacentElement("beforebegin", newBtn);
      } else {
        document.getElementById("adminUI").appendChild(newBtn);
      }
    } else {
    }
  } else if (data.action === "closeUI") {
    document.getElementById("ticketUI").classList.add("hidden");
    document.getElementById("adminUI").classList.add("hidden");
    body.classList.remove("active");
    body.classList.add("hidden");
  } else if (data.action === "updateAdminList") {
    updateAdminUI(data.tickets);
  } else if (data.action === "showStats") {
    const statsDiv = document.getElementById("statsSection");
    statsDiv.innerHTML = "<h4>Ticket Statistics</h4><ul>";

    data.stats.forEach(stat => {
      statsDiv.innerHTML += `<li><strong>${stat.admin_name}</strong>: Total tickets: ${stat.total}, Tickets in the last 30 days: ${stat.last_30_days}</li>`;
    });

    statsDiv.innerHTML += "</ul>";
    statsDiv.style.display = "block";
  }
});

function submitTicket() {
  const reason = document.getElementById("reason").value.trim();
  if (!reason || reason === "") {
    alert("Please write a reason!");
    return;
  }

  fetch("https://rsg-ticket/submitTicket", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ reason })
  });

  closeUI();
}

function closeUI() {
  fetch("https://rsg-ticket/closeUI", {
    method: "POST"
  });
}

function claimTicket(id, target) {
  fetch("https://rsg-ticket/claimTicket", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id, target })
  });

  closeUI();
}

function updateAdminUI(tickets) {
  const container = document.getElementById("ticketList");
  container.innerHTML = "";

  if (!tickets || tickets.length === 0) {
    container.innerHTML = "<p>There are no active tickets.</p>";
    return;
  }

  tickets.forEach(ticket => {
    const div = document.createElement("div");
    div.className = "ticket-item";

    const detailsId = `details-${ticket.id}`;

    div.innerHTML = `
      <strong>${ticket.player_name} | ID: ${ticket.player_cid}</strong>
      <br>
      <button onclick="toggleDetails('${detailsId}')">Details</button>
      <div id="${detailsId}" class="ticket-details" style="display: none;">
        <pre>${ticket.reason}</pre>
        <button onclick="claimTicket(${ticket.id}, ${ticket.player_id})">Claim</button>
      </div>
    `;

    container.appendChild(div);
  });
}




function toggleDetails(id) {
  const el = document.getElementById(id);
  el.style.display = el.style.display === "none" ? "block" : "none";
}

function requestStats() {
  const statsDiv = document.getElementById("statsSection");

  if (statsDiv.style.display === "block") {
    statsDiv.style.display = "none";
    statsDiv.innerHTML = "";
    return;
  }

  fetch("https://rsg-ticket/requestStats", {
    method: "POST"
  });

  statsDiv.innerHTML = "<p>Loading...</p>";
  statsDiv.style.display = "block";
}



