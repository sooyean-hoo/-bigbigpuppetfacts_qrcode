require_relative '../bbpfdrivers.rb'

# Drivers to Load the BARCODE method
class BBPFDrivers::BARCODE
  def initialise; end

  def compressmethods
    c = {
      'barcode' => proc { |data, _info: {}| # rubocop:disable Lint/UnderscorePrefixedVariableName
        codename ||= _info['m']
        codename ||= 'Code39'
        codename = codename.gsub('barcode::', '') if @barcodeparts[:encode].key?(codename.gsub('barcode::', ''))

        barcode = if ['barcode' ].include?(codename)
                    Barby::Code39.new(data, true)
                  else
                    Object.const_get("Barby::#{codename}").new(data)
                  end

        # barcode = Barby::Code39.new(data, true)
        "\n" + barcode.to_ascii({ bar: 0x2588.chr('UTF-8') })
      }
    }
    autoload_declare if @barcodeparts.nil?
    return c if @barcodeparts.nil?
    @barcodeparts[:encode].each_key do |mname|
      c[ "barcode::#{mname}" ] = proc { |data, _info: {}| # rubocop:disable Lint/UnderscorePrefixedVariableName
        codename ||= _info['m']
        codename ||= 'Code39'
        codename = codename.gsub('barcode::', '') if @barcodeparts[:encode].key?(codename.gsub('barcode::', ''))

        barcode = if ['barcode' ].include?(codename)
                    Barby::Code39.new(data, true)
                  else
                    Object.const_get("Barby::#{codename}").new(data)
                  end

        # barcode = Barby::Code39.new(data, true)
        "\n" + barcode.to_ascii({ bar: 0x2588.chr('UTF-8') })
      }
    end
    c
  end

  def decompressmethods
    d = {
      'barcode' => proc { |data, _info: {}| data }
    }
    autoload_declare if @barcodeparts.nil?
    return d if @barcodeparts.nil?
    @barcodeparts[:encode].each_key do |mname|
      d["barcode::#{mname}"] = proc { |data, _info: {}| data }
    end
    d
  end

  alias encodemethods compressmethods

  alias decodemethods decompressmethods

  def test_methods
    t = {
      'barcode' => proc { |data, _info: {}|
        data
        methodname = if _info.key?('m')
                       _info['m']
                     else
                       'barcode'
                     end
        numdata=data.gsub(/[^0-9]/,'')
        data if compressmethods[methodname].call(numdata, _info: _info).start_with?("\n█")
        # Adjusted it... For BarCode, there is not such thing as inverse function. So This test is change to check QR codes is generated properly.
      }
    }
    autoload_declare if @barcodeparts.nil?
    return t if @barcodeparts.nil?
    @barcodeparts[:encode].each_key do |mname|
      methodname = "barcode::#{mname}"
      t[methodname] = proc { |data, _info: {}| test_methods['barcode'].call(data, _info: _info)  } # rubocop:disable Lint/UnderscorePrefixedVariableName
    end
    t
  end

  def autoload_declare
    lib_path = File.join(File.dirname(__FILE__), '../../../facter/util/barby-0.6.8/lib/')
    $LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)

    autoload :Barby, 'barby'

    skipclasses = ['DataMatrix', 'QrCode', 'Pdf417', 'directly']
    @barcodeparts ||= Facter::Util::Bigbigpuppetfacts.loaddrivers([ File.join(File.dirname(__FILE__), '../../../facter/util/barby-0.6.8/lib/barby/barcode/*.rb') ],
    opts: { loadonly: true, skipclasses: skipclasses })
    #    require 'barby/barcode/bookland'
    #    require 'barby/barcode/codabar'
    #    require 'barby/barcode/code_128'
    #    require 'barby/barcode/code_25'
    #    require 'barby/barcode/code_25_iata'
    #    require 'barby/barcode/code_25_interleaved'
    #    require 'barby/barcode/code_39'
    #    require 'barby/barcode/code_93'
    #    require 'barby/barcode/ean_13'
    #    require 'barby/barcode/ean_8'
    #    require 'barby/barcode/gs1_128'
    #    require 'barby/barcode/upc_supplemental'
    #    require 'barby/barcode/pdf_417'
    #    require 'barby/barcode/qr_code'
    #    require 'barby/barcode/data_matrix'
    @barcodeparts = Facter::Util::Bigbigpuppetfacts.loaddrivers([ File.join(File.dirname(__FILE__), '../../../facter/util/valente_barcode/lib/barby/barcode/*.rb') ],
      @barcodeparts,
      opts: { loadonly: true, skipclasses: skipclasses })

    skipclasses = ['CairoOutputter', 'HtmlOutputter', 'PDFWriterOutputter', 'PngOutputter', 'PrawnOutputter', 'RmagickOutputter', 'SvgOutputter']
    @barcodeouts ||= Facter::Util::Bigbigpuppetfacts.loaddrivers([File.join(File.dirname(__FILE__), '../../../facter/util/barby-0.6.8/lib/barby/outputter/*.rb')],
opts: { loadonly: true, skipclasses: skipclasses })
    #    require 'barby/outputter/ascii_outputter'
    #    require 'barby/outputter/cairo_outputter'
    #    require 'barby/outputter/html_outputter'
    #    require 'barby/outputter/pdfwriter_outputter'
    #    require 'barby/outputter/png_outputter'
    #    require 'barby/outputter/prawn_outputter'
    #    require 'barby/outputter/rmagick_outputter'
    #    require 'barby/outputter/svg_outputter'
  end
end
