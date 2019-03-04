require 'json'

class VisionApi
  include HTTParty
  
  # Hi the api and get the data
  def self.fetch_data(api_body)
    url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['VISION_API_KEY']}"

    data_json = api_body.to_json

    response = HTTParty.post(url, body: data_json, headers: {'Content-Type' => 'application/json'})

    parsed_data = JSON.parse(response.body)

    words = parsed_data["responses"][0]["textAnnotations"].map { |text| text["description"]}

    puts JSON.pretty_generate(words)
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
