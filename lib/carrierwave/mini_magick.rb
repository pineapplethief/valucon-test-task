module CarrierWave
  module MiniMagick
    # to prevent known DoS exploit,see:
    # https://github.com/carrierwaveuploader/carrierwave/wiki/Denial-of-service-vulnerability-with-maliciously-crafted-JPEGs--(pixel-flood-attack)
    def validate_dimensions
      manipulate! do |img|
        if img.dimensions.any?{|i| i > 5000 }
          raise CarrierWave::ProcessingError, 'dimensions too large'
        end
        img
      end
    end

    # usage: call process method in your uploaders like that:
    # process(quality: 85)
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    # process(strip) to strip exif info and save some disk space
    def strip
      manipulate! do |img|
        img.strip
        img = yield(img) if block_given?
        img
      end
    end

  end
end
