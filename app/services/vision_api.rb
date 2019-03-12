require 'json'

TODAY = Date.today

# REGEX TO EXTRACT DATA
REGEX = /[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[0-9]/
DATE_REGEX = /([1-9]|[0-2]{2})月(\s?)([1-4]|[0-9]{1,2})日/
YEN_REGEX = /(\d+,\s*\d{3})円?/


class VisionApi
  include HTTParty
  # Hi the api and get the data
  def self.filter_words(words_array)
    words_array.map { |word| word if REGEX =~ word }
  end

  def self.create_due_date(dates)
    dates = dates.map do |date|
      date.delete_at(1)
      month = date[0].to_i
      day = date[1].to_i
      if (month > TODAY.mon) && (month == 1)
        Date.new(Date.today.year, month, day).next_year
      else
        Date.new(Date.today.year, month, day)
      end
    end
    due_this_month = nil
    due_next_month = nil
    past_due = nil
 
    dates.each do |date|
      if TODAY.mon == date.mon && (TODAY - date).to_i.negative?
        due_this_month = date
      elsif (TODAY.mon - date.mon).to_i < 30 && !TODAY.mon
        due_next_month = date
      else
        past_due = date
      end
    end
    due_next_month || due_this_month || past_due
  end

  def self.create_amount_due(yen_array)
    yen_array.flatten.map do |yen|
      yen.split(",").join("").gsub(/\s+/, "").to_i
    end.max
  end

  def self.extract_date(detected_text)
    create_due_date(detected_text.scan(DATE_REGEX))
  end

  def self.extract_yen(detected_text)
    create_amount_due(detected_text.scan(YEN_REGEX))
  end

  def self.fetch_data(api_body)
    url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['VISION_API_KEY']}"

    data_json = api_body.to_json

    response = HTTParty.post(url, body: data_json, headers: { 'Content-Type' => 'application/json' })

    parsed_data = JSON.parse(response.body)

    words = parsed_data["responses"][0]["textAnnotations"].map { |text| text["description"] }

    puts JSON.pretty_generate(words)

    boxes = parsed_data["responses"][0]["textAnnotations"].map { |text| text["boundingPoly"]["vertices"] }

    all_text = words.shift

    p extract_yen(all_text).to_i
    return {
      text: all_text,
      words: filter_words(words),
      boundingPolys: boxes,
      due_date: extract_date(all_text),
      due_amount: extract_yen(all_text).to_i
    }
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
