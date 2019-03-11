import 'bootstrap';



const nav = document.querySelector('#navigation');
const dropdown = document.querySelector('#navigation__hamburger');
const mobileNav = document.querySelector('.navigation__drop');

window.addEventListener('scroll', e => {
  if (window.scrollY > 100) {
    nav.classList.add('sticky-nav');
    nav.classList.remove('fadeout');
  } else {
    nav.classList.remove('sticky-nav');
    nav.style.background = '$primary';
    nav.style.color = '#000';
  }
});

dropdown.addEventListener('click', e => {
  console.log('clicked');
  mobileNav.classList.toggle('navigation__drop');
  mobileNav.classList.toggle('dropdown');
});
