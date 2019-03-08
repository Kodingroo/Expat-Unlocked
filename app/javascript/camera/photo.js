(function loadVideo () {
  var video = document.getElementByID('video'),
    vendorUrl = window.URL || window.webkitURL;

  navigator.getMedia =  navigator.getUserMedia ||
                        navigator.webkitGetUserMedia ||
                        navigator.mozGetUserMedia ||
                        navigator.msGetUserMedia
  navigator.getMedia({
    video: true,
    audio: false
  }, function(stream){
    video.src = vendorUrl.createObjectURL(stream);
    video.play();
  }, function(error) {
    //an error occured
    //error.code
  });
})();

export { loadVideo };
