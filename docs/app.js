// State & Data
const state = {
  activeCircle: null,
  statusFilter: 'ALL', // ALL, LOST, FOUND, CLAIMED
  onlyToday: false,
  searchQuery: '',
  circles: [
    {
      id: 'mit_circle',
      name: 'MIT Campus Circle',
      passcode: 'MIT-FOUND',
      location: 'Cambridge, MA',
      badge: '🏛️',
      members: 4250
    },
    {
      id: 'stanford_circle',
      name: 'Stanford University',
      passcode: 'STANFORD-2026',
      location: 'Stanford, CA',
      badge: '🌲',
      members: 6100
    },
    {
      id: 'oxford_circle',
      name: 'University of Oxford',
      passcode: 'OXFORD-101',
      location: 'Oxford, UK',
      badge: '🎓',
      members: 3890
    }
  ],
  items: [
    {
      id: 'item_1',
      circleId: 'mit_circle',
      status: 'FOUND',
      title: 'Apple MacBook Air (Space Gray)',
      category: 'Electronics',
      description: 'Found on 3rd floor study desk in the Central Library. Has a sticker of NASA on top lid.',
      location: 'Central Library, 3rd Floor Desk 14',
      storage: 'Main Gate Security Desk',
      contactName: 'Alex Rivera (Security Officer)',
      contactPhone: '+1 (555) 019-2831',
      contactEmail: 'alex.rivera@mit.edu',
      photo: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
      date: new Date().toISOString()
    },
    {
      id: 'item_2',
      circleId: 'mit_circle',
      status: 'LOST',
      title: 'Blue Leather Wallet with Student ID',
      category: 'Wallet',
      description: 'Lost somewhere between Science Block B and Student Dining Hall around lunch time.',
      location: 'Pathway near Science Block B',
      storage: 'Searching / With Student',
      contactName: 'Sarah Jenkins',
      contactPhone: '+1 (555) 014-9922',
      contactEmail: 's.jenkins@student.mit.edu',
      photo: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=500',
      date: new Date().toISOString()
    },
    {
      id: 'item_3',
      circleId: 'stanford_circle',
      status: 'FOUND',
      title: 'Set of 4 Brass Keys with Red Keychain',
      category: 'Keys',
      description: 'Found near the Outdoor Basketball Courts after 5 PM pickup game.',
      location: 'Sports Complex Basketball Court 2',
      storage: 'Sports Admin Desk (Room 102)',
      contactName: 'Coach Michael',
      contactPhone: '+1 (555) 018-4411',
      contactEmail: 'm.coach@stanford.edu',
      photo: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=500',
      date: new Date().toISOString()
    },
    {
      id: 'item_4',
      circleId: 'mit_circle',
      status: 'CLAIMED',
      title: 'Calculus & Physics Textbooks in Nike Bag',
      category: 'Bag / Books',
      description: 'Black Nike backpack containing 2 textbooks and a blue pencil pouch.',
      location: 'Engineering Auditorium 101',
      storage: 'Returned to Owner',
      contactName: 'Jessica Wu',
      contactPhone: '+1 (555) 012-7744',
      contactEmail: 'j.wu@student.mit.edu',
      photo: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      date: new Date(Date.now() - 86400000).toISOString()
    }
  ]
};

// Clock
function updateClock() {
  const now = new Date();
  const hrs = String(now.getHours()).padStart(2, '0');
  const mins = String(now.getMinutes()).padStart(2, '0');
  document.getElementById('clock').textContent = `${hrs}:${mins}`;
}
setInterval(updateClock, 1000);
updateClock();

// Passcode Fill Helper
function fillPasscode(code) {
  document.getElementById('passcode-input').value = code;
}

// Join Passcode Action
function handleJoinPasscode() {
  const input = document.getElementById('passcode-input').value.trim().toUpperCase();
  const found = state.circles.find(c => c.passcode.toUpperCase() === input);

  if (found) {
    state.activeCircle = found;
    document.getElementById('auth-error').classList.add('hidden');
    showDashboardView();
  } else {
    document.getElementById('auth-error').classList.remove('hidden');
  }
}

// Leave Circle
function handleLeaveCircle() {
  state.activeCircle = null;
  document.getElementById('view-dashboard').classList.add('hidden');
  document.getElementById('view-passcode').classList.remove('hidden');
}

// Switch Views
function showDashboardView() {
  document.getElementById('view-passcode').classList.add('hidden');
  document.getElementById('view-dashboard').classList.remove('hidden');

  // Set Header Info
  document.getElementById('circle-badge').textContent = state.activeCircle.badge;
  document.getElementById('circle-name').textContent = state.activeCircle.name;
  document.getElementById('circle-meta').textContent = `Passcode: ${state.activeCircle.passcode} • ${state.activeCircle.members} members`;

  renderItems();
}

// Filter Controls
function setStatusFilter(status, el) {
  state.statusFilter = status;
  document.querySelectorAll('.status-chip').forEach(c => c.classList.remove('active'));
  el.classList.add('active');
  renderItems();
}

function toggleTodayFilter() {
  state.onlyToday = !state.onlyToday;
  const btn = document.getElementById('today-toggle');
  if (state.onlyToday) {
    btn.classList.add('active');
  } else {
    btn.classList.remove('active');
  }
  renderItems();
}

// Render Items Feed
function renderItems() {
  const container = document.getElementById('items-container');
  const query = document.getElementById('search-input').value.trim().toLowerCase();

  const filtered = state.items.filter(item => {
    if (item.circleId !== state.activeCircle.id) return false;
    if (state.statusFilter !== 'ALL' && item.status !== state.statusFilter) return false;
    
    if (state.onlyToday) {
      const itemDate = new Date(item.date).toDateString();
      const today = new Date().toDateString();
      if (itemDate !== today) return false;
    }

    if (query) {
      const titleMatch = item.title.toLowerCase().includes(query);
      const descMatch = item.description.toLowerCase().includes(query);
      const locMatch = item.location.toLowerCase().includes(query);
      if (!titleMatch && !descMatch && !locMatch) return false;
    }

    return true;
  });

  if (filtered.length === 0) {
    container.innerHTML = `
      <div style="text-align:center; padding: 40px 20px; color: #94a3b8;">
        <i class="fa-solid fa-folder-open" style="font-size: 48px; margin-bottom: 12px; color: #cbd5e1;"></i>
        <h4 style="font-size: 16px; color: #334155; margin-bottom: 6px;">No items reported yet!</h4>
        <p style="font-size: 12px;">Be the first to report a lost or found item in your campus circle.</p>
      </div>
    `;
    return;
  }

  container.innerHTML = filtered.map(item => {
    const isToday = new Date(item.date).toDateString() === new Date().toDateString();
    const dateFormatted = new Date(item.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });

    let badgeClass = 'badge-found';
    if (item.status === 'LOST') badgeClass = 'badge-lost';
    if (item.status === 'CLAIMED') badgeClass = 'badge-claimed';

    return `
      <div class="item-card" onclick="openDetailModal('${item.id}')">
        <div class="card-img-wrap">
          <img src="${item.photo}" alt="${item.title}" onerror="this.src='https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=500'">
          <span class="card-badge ${badgeClass}">${item.status}</span>
          ${isToday ? `<span class="badge-today">⚡ TODAY</span>` : ''}
        </div>
        <div class="card-body">
          <div class="card-title-row">
            <h4>${item.title}</h4>
            <span class="cat-chip">${item.category}</span>
          </div>
          <p class="card-desc">${item.description}</p>
          <div class="card-meta-line">
            <i class="fa-solid fa-location-dot"></i>
            <span>Lost/Found at: ${item.location}</span>
          </div>
          <div class="card-meta-line" style="color: #0d9488; font-weight: 600;">
            <i class="fa-solid fa-pin"></i>
            <span>Current Spot: ${item.storage}</span>
          </div>
          <div class="card-meta-line" style="font-size: 10px; color: #94a3b8; justify-content: flex-end; margin-top: 6px;">
            <span>${dateFormatted}</span>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

// Modals Setup
function showReportModal() {
  document.getElementById('report-modal').classList.remove('hidden');
}

function closeReportModal() {
  document.getElementById('report-modal').classList.add('hidden');
}

function showCreateModal() {
  document.getElementById('create-circle-modal').classList.remove('hidden');
}

function closeCreateModal() {
  document.getElementById('create-circle-modal').classList.add('hidden');
}

function closeDetailModal() {
  document.getElementById('detail-modal').classList.add('hidden');
}

// Report Form Submit
function handleReportSubmit(e) {
  e.preventDefault();
  const status = document.querySelector('input[name="itemStatus"]:checked').value;
  const title = document.getElementById('form-title').value.trim();
  const category = document.getElementById('form-category').value;
  const description = document.getElementById('form-desc').value.trim();
  const location = document.getElementById('form-location').value.trim();
  const storage = document.getElementById('form-storage').value.trim();
  const contactName = document.getElementById('form-contact-name').value.trim();
  const contactPhone = document.getElementById('form-contact-phone').value.trim();
  const contactEmail = document.getElementById('form-contact-email').value.trim();
  const photo = document.getElementById('form-photo').value.trim() || 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500';

  const newItem = {
    id: `item_${Date.now()}`,
    circleId: state.activeCircle.id,
    status,
    title,
    category,
    description,
    location,
    storage,
    contactName,
    contactPhone,
    contactEmail,
    photo,
    date: new Date().toISOString()
  };

  state.items.unshift(newItem);
  closeReportModal();
  document.getElementById('report-form').reset();
  renderItems();
}

// Open Detail View
function openDetailModal(itemId) {
  const item = state.items.find(i => i.id === itemId);
  if (!item) return;

  const content = document.getElementById('detail-content');
  const dateFormatted = new Date(item.date).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });

  let badgeColor = '#43a047';
  if (item.status === 'LOST') badgeColor = '#e53935';
  if (item.status === 'CLAIMED') badgeColor = '#757575';

  content.innerHTML = `
    <div style="border-radius: 12px; overflow: hidden; margin-bottom: 14px; position: relative;">
      <img src="${item.photo}" style="width: 100%; height: 200px; object-fit: cover;">
      <span style="position: absolute; top: 10px; left: 10px; background: ${badgeColor}; color: #fff; padding: 4px 10px; border-radius: 12px; font-weight: 800; font-size: 11px;">
        ${item.status} ITEM
      </span>
    </div>

    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 4px;">${item.title}</h3>
    <p style="font-size: 11px; color: #64748b; margin-bottom: 12px;">Reported on ${dateFormatted}</p>

    <div style="background: #f8fafc; border-left: 4px solid #3f51b5; padding: 10px; border-radius: 6px; font-size: 12px; margin-bottom: 14px; line-height: 1.4;">
      <strong>Remarks & Description:</strong><br>${item.description}
    </div>

    <div style="background: #e0f2fe; padding: 10px; border-radius: 8px; font-size: 12px; margin-bottom: 8px; color: #0369a1;">
      <i class="fa-solid fa-location-dot"></i> <strong>Place Lost/Found:</strong> ${item.location}
    </div>

    <div style="background: #ccfbf1; padding: 10px; border-radius: 8px; font-size: 12px; margin-bottom: 16px; color: #0f766e;">
      <i class="fa-solid fa-pin"></i> <strong>Current Storage Spot:</strong> ${item.storage}
    </div>

    <div style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 14px; margin-bottom: 16px;">
      <h4 style="font-size: 13px; color: #334155; margin-bottom: 8px;"><i class="fa-solid fa-user-shield"></i> Designated Contact Info</h4>
      <p style="font-size: 13px; font-weight: 700;">${item.contactName}</p>
      <p style="font-size: 12px; color: #475569;">📞 ${item.contactPhone}</p>
      <p style="font-size: 12px; color: #475569;">✉️ ${item.contactEmail}</p>
    </div>

    ${item.status !== 'CLAIMED' ? `
      <button class="btn btn-primary btn-block" style="background: #0d9488;" onclick="markItemClaimed('${item.id}')">
        <i class="fa-solid fa-circle-check"></i> MARK AS CLAIMED / RETURNED
      </button>
    ` : ''}
  `;

  document.getElementById('detail-modal').classList.remove('hidden');
}

function markItemClaimed(itemId) {
  const item = state.items.find(i => i.id === itemId);
  if (item) {
    item.status = 'CLAIMED';
    closeDetailModal();
    renderItems();
  }
}

// Create Circle Submit
function handleCreateCircleSubmit(e) {
  e.preventDefault();
  const name = document.getElementById('new-circle-name').value.trim();
  const code = document.getElementById('new-circle-code').value.trim().toUpperCase();
  const location = document.getElementById('new-circle-loc').value.trim();

  const newCircle = {
    id: `circle_${Date.now()}`,
    name,
    passcode: code,
    location,
    badge: '🏫',
    members: 1
  };

  state.circles.push(newCircle);
  state.activeCircle = newCircle;
  closeCreateModal();
  document.getElementById('create-circle-form').reset();
  showDashboardView();
}
