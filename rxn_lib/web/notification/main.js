window.addEventListener('message', function(event) {
    if (event.data.action === "showNotification") {
        const { duration, color, message, icon } = event.data;
        showNotification(duration, color, message, icon);
    }
});

function showNotification(duration, color, message, icon) {
    const notifContainer = document.getElementById('notif-container');
    const notif = document.createElement('div');
    notif.id = 'notiback';
    const notifText = document.createElement('div');
    notifText.id = 'notif-text';
    const notifIcon = document.createElement('i');
    notifIcon.id = 'notif-icon';

    notif.appendChild(notifIcon);
    notif.appendChild(notifText);
    notifContainer.appendChild(notif);

    notif.classList.remove(
        'border-red', 
        'border-blue', 
        'border-green', 
        'border-rainbow',
        'border-yellow',
        'border-orange',
        'border-purple',
        'border-pink',
        'border-brown',
        'border-gray',
        'border-black',
        'border-white',
        'border-beige',
        'border-maroon',
        'border-olive',
        'border-teal',
        'border-lime',
        'border-cyan',
        'border-magenta',
        'border-indigo',
        'border-violet',
        'border-turquoise',
        'border-gold',
        'border-silver',
        'border-bronze',
        'border-khaki',
        'border-lavender',
        'border-coral',
        'border-peach',
        'border-crimson',
        'border-chocolate',
        'border-sienna',
        'border-salmon',
        'border-plum',
        'border-slategray',
        'border-royalblue',
        'border-mediumpurple',
        'border-darkgreen',
        'border-darkblue',
        'border-seagreen'
    );
    notifIcon.setAttribute('class', '');
    notifText.innerText = message;

    const iconClasses = icon.split(' ');
    iconClasses.forEach(cls => notifIcon.classList.add(cls));

    switch (color.toLowerCase()) {
        case 'red':
            notif.classList.add('border-red');
            break;
        case 'green':
            notif.classList.add('border-green');
            break;
        case 'blue':
            notif.classList.add('border-blue');
            break;
        case 'yellow':
            notif.classList.add('border-yellow');
            break;
        case 'orange':
            notif.classList.add('border-orange');
            break;
        case 'purple':
            notif.classList.add('border-purple');
            break;
        case 'pink':
            notif.classList.add('border-pink');
            break;
        case 'brown':
            notif.classList.add('border-brown');
            break;
        case 'gray':
            notif.classList.add('border-gray');
            break;
        case 'black':
            notif.classList.add('border-black');
            break;
        case 'white':
            notif.classList.add('border-white');
            break;
        case 'beige':
            notif.classList.add('border-beige');
            break;
        case 'maroon':
            notif.classList.add('border-maroon');
            break;
        case 'olive':
            notif.classList.add('border-olive');
            break;
        case 'teal':
            notif.classList.add('border-teal');
            break;
        case 'lime':
            notif.classList.add('border-lime');
            break;
        case 'cyan':
            notif.classList.add('border-cyan');
            break;
        case 'magenta':
            notif.classList.add('border-magenta');
            break;
        case 'indigo':
            notif.classList.add('border-indigo');
            break;
        case 'violet':
            notif.classList.add('border-violet');
            break;
        case 'turquoise':
            notif.classList.add('border-turquoise');
            break;
        case 'gold':
            notif.classList.add('border-gold');
            break;
        case 'silver':
            notif.classList.add('border-silver');
            break;
        case 'bronze':
            notif.classList.add('border-bronze');
            break;
        case 'khaki':
            notif.classList.add('border-khaki');
            break;
        case 'lavender':
            notif.classList.add('border-lavender');
            break;
        case 'coral':
            notif.classList.add('border-coral');
            break;
        case 'peach':
            notif.classList.add('border-peach');
            break;
        case 'crimson':
            notif.classList.add('border-crimson');
            break;
        case 'chocolate':
            notif.classList.add('border-chocolate');
            break;
        case 'sienna':
            notif.classList.add('border-sienna');
            break;
        case 'salmon':
            notif.classList.add('border-salmon');
            break;
        case 'plum':
            notif.classList.add('border-plum');
            break;
        case 'slategray':
            notif.classList.add('border-slategray');
            break;
        case 'royalblue':
            notif.classList.add('border-royalblue');
            break;
        case 'mediumpurple':
            notif.classList.add('border-mediumpurple');
            break;
        case 'darkgreen':
            notif.classList.add('border-darkgreen');
            break;
        case 'darkblue':
            notif.classList.add('border-darkblue');
            break;
        case 'seagreen':
            notif.classList.add('border-seagreen');
            break;
        default:
            notif.classList.add('border-red');
            break;
    }    

    notif.classList.remove('hide-notif');
    notif.classList.add('show-notif');

    adjustNotifPosition();

    setTimeout(() => {
        notif.classList.remove('show-notif');
        notif.classList.add('hide-notif');
    }, duration);

    notif.addEventListener('transitionend', function () {
        if (notif.classList.contains('hide-notif')) {
            notif.remove();
            adjustNotifPosition();
        }
    });
}

function adjustNotifPosition() {
    const notifContainer = document.getElementById('notif-container');
    let offset = 0;

    const allNotifs = notifContainer.querySelectorAll('#notiback');

    allNotifs.forEach((notif, index) => {
        notif.style.position = 'absolute';
        notif.style.top = `${offset}px`;
        offset += notif.offsetHeight + 10;
    });
}
