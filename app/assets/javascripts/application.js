//= require rails-ujs
//= require_tree .
//= require bootstrap-datepicker

function loader() {
  var upload = document.querySelector('.upload-document');
  console.log(upload.form);

  // alert('submitting');
  var loading = document.createElement('span');
  var title = document.createElement('p');

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
