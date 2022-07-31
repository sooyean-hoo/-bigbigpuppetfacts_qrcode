require_relative '../bbpfdrivers.rb'

# Drivers to Load the QR method
class BBPFDrivers::QR
  def initialise; end

  def compressmethods
    {
      'qr' => proc { |data, _info: {}|
        qr = RQRCode::QRCode.new(data)
        "\n" + qr.to_s(dark: 0x2588.chr('UTF-8'), light: ' ')
      }
    }
  end

  def decompressmethods
    {
      'qr' => proc { |data, _info: {}| data }
    }
  end

  alias encodemethods compressmethods

  alias decodemethods decompressmethods

  def test_methods
    {
      'qr' => proc { |data, _info: {}| # rubocop:disable Lint/UnderscorePrefixedVariableName
        #        decompressmethods['xz'].call(
        #          compressmethods['xz'].call(data, _info: _info), _info: _info
        #        )
        data if compressmethods['qr'].call(data, _info: _info).start_with?("\n█")
        # Adjusted it... For QR Code, there is not such thing as inverse function. So This test is change to check QR codes is generated properly.
      }
    }
  end

  def autoload_declare
    lib_path = File.join(File.dirname(__FILE__), '../../../facter/util/rqrcode-2.1.1/lib/')
    $LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)

    lib_path = File.join(File.dirname(__FILE__), '../../../facter/util/rqrcode_core-1.2.0/lib/')
    $LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)

    lib_path = File.join(File.dirname(__FILE__), '../../../facter/util/chunky_png-1.4.0/lib/')
    $LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)

    autoload :RQRCode, 'rqrcode'
    autoload :RQRCodeCore, 'rqrcode_core'
    autoload :ChunkyPNG, 'chunky_png'
  end
end
