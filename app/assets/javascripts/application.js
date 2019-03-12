//= require rails-ujs
//= require_tree .
function loader() {
  var upload = document.querySelector('.upload-document');
  console.log(upload.form);

  // alert('submitting');
  var loading = document.createElement('span');
  var title = document.createElement('p');

  title.innerText = 'Detecting Image';
  title.style.fontWeight = 'bold';

  loading.classList.add('pulse');

  upload.form.insertAdjacentElement('beforeend', title);
  upload.form.insertAdjacentElement('afterend', loading);

  upload.form.submit();
  upload.style.display = 'none';
  upload.disabled = true;
}
