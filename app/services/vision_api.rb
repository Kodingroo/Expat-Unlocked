require 'json'

REGEX = /[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]/


class VisionApi
  include HTTParty
  # Hi the api and get the data
  def self.filter_words(words_array)
    words_array.map { |word| word if REGEX =~ word }
  end

  def self.fetch_data(api_body)
    url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['VISION_API_KEY']}"

    data_json = api_body.to_json

    response = HTTParty.post(url, body: data_json, headers: {'Content-Type' => 'application/json'} )

    parsed_data = JSON.parse(response.body)

    words = parsed_data["responses"][0]["textAnnotations"].map { |text| text["description"] }

    boxes = parsed_data["responses"][0]["textAnnotations"].map { |text| text["boundingPoly"]["vertices"] }
    words.shift
    { words: filter_words(words), boundingPolys: boxes }
    # FOR TESTING PURPOSES ONLY
    # puts JSON.pretty_generate(filter_words(words))
    # puts JSON.pretty_generate(words)
  end

  # send the image to the api and detect the text
  def self.detect_user_image(image)
    data = {
      'requests': [
        {
          'image': {
            'source': {
              'imageUri': image
            }
          },
          'features': [
            {
              'type': 'DOCUMENT_TEXT_DETECTION'
            }
          ]
        }
      ]
    }
    fetch_data(data)
  end
end
