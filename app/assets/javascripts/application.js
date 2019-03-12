//= require rails-ujs
//= require_tree .
function loader() {
  const upload = document.querySelector('.upload-document');
  console.log(upload.form);

  // alert('submitting');
  const loading = document.createElement('span');
  const title = document.createElement('p');

  title.innerText = 'Detecting Image';
  title.style.fontWeight = 'bold';
  title.style.paddingBottom = '10px';

  loading.classList.add('pulse');

  upload.form.insertAdjacentElement('beforeend', title);
  upload.form.insertAdjacentElement('afterend', loading);

  upload.form.submit();
  upload.parentNode.style.display = 'none';
  upload.disabled = true;
}
