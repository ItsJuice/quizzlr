require 'carrierwave/processing/rmagick'

module Quizzlr
  class QuestionImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick

    def store_dir
      #{Quizzlr.image_upload_path}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :question_image do
      process resize_to_fill: Quizzlr.question_image_dimensions
    end
  end
end