require 'carrierwave/processing/rmagick'

module Quizzlr
  class QuizImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick

    def store_dir
      "#{Quizzlr.image_upload_path}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :quiz_image do
      process resize_to_fill: Quizzlr.intro_image_dimensions
    end

  end
end