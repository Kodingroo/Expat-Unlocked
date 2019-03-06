import 'bootstrap';

const nav = document.querySelector('#navigation');

0;

const runOnScroll = () => {
  if (document.body.scrollTop >= 200) {
    nav.classList.add('navbar-top-fixed');
  }
};

window.addEventListener('scroll', e => {
  if (window.scrollY > 100) {
    nav.style.background = '$primary';
    nav.style.color = '#fff';
    nav.classList.add('sticky-nav');
    nav.classList.remove('fadeout');
  } else {
    nav.classList.remove('sticky-nav');
    nav.style.background = '$primary';
    nav.style.color = '#000';
  }
});
