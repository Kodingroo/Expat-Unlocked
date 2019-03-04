require 'httparty'
require 'json'

DATA = {
  'requests': [
    {
      'image': {
        'source': {
          'imageUri': 'https://resources.realestate.co.jp/wp-content/uploads/2018/09/Tenshutsu-Todoke-Notice-of-Moving-Out-Japan.png',
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

class VisionApi
  def fetch_document_data
    url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['VISION_API_KEY']}"

    data_json = DATA.to_json

    response = HTTParty.post(url, body: data_json, headers: {'Content-Type' => 'application/json'})

    parsed_data = JSON.parse(response.body)

    puts JSON.pretty_generate(parsed_data)
  end
end
