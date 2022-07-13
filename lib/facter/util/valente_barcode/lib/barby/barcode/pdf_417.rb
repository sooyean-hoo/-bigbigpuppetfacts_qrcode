require 'barby/barcode'
#require 'java'
#require 'Pdf417lib'
#import 'Pdf417lib'

require "open3"

module Barby
  class Pdf417Valente < Barcode2D
    DEFAULT_OPTIONS = {
      :options       => 0,
      :y_height      => 3,
      :aspect_ratio  => 0.5,
      :error_level   => 0,
      :len_codewords => 0,
      :code_rows     => 0,
      :code_columns  => 0
    }

    # Creates a new Pdf417 barcode. The +options+ argument
    # can use the same keys as DEFAULT_OPTIONS. Please consult
    # the source code of Pdf417lib.java for details about values
    # that can be used.
    def initialize(data, options={})
      #@pdf417 = Java::Pdf417lib.new
      #self.data = data
      @data = data
      DEFAULT_OPTIONS.merge(options)#.each{|k,v| send("#{k}=", v) }
    end

#    def options=(options)
#      @options = options
#    end
#
#    def y_height=(y_height)
#      @pdf417.setYHeight(y_height)
#    end
#
#    def aspect_ratio=(aspect_ratio)
#      @pdf417.setAspectRatio(aspect_ratio)
#    end
#
#    def error_level=(error_level)
#      @pdf417.setErrorLevel(error_level)
#    end
#
#    def len_codewords=(len_codewords)
#      @pdf417.setLenCodewords(len_codewords)
#    end
#
#    def code_rows=(code_rows)
#      @pdf417.setCodeRows(code_rows)
#    end
#
#    def code_columns=(code_columns)
#      @pdf417.setCodeColumns(code_columns)
#    end
#
#    def data=(data)
#      @pdf417.setText(data)
#    end

    def pdf417_paintCode
      return @pdf417_paintCode_ret unless @pdf417_paintCode_ret.nil?

      javafile = File.join(File.dirname(__FILE__), '../../vendor/lib/Pdf417lib.java')
      psfile =  File.join(File.dirname(__FILE__), 'a.ps')

      cmd1="java #{javafile} #{psfile} '#{@data}'    "
      cmd3='tee'

      `(  java --version > /dev/null || sudo yum install -y java   ) `

      env2use = ENV.to_hash
      #env2use.merge!(_info)
      output=''
      Open3.pipeline_rw([env2use, cmd1], cmd3) do |i, o, _ts|
        i.puts @data
        i.close
        output=o.read
      end
      @pdf417_paintCode_ret= JSON.load(File.read("#{psfile}.json"))
    end
     def pdf417_getBitColumns
       pdf417_paintCode['bitColumns']
     end
     def pdf417_getOutBits
       pdf417_paintCode['OutBits']
     end
     def encoding
       pdf417_paintCode()

       cols = (pdf417_getBitColumns() - 1) / 8 + 1
       enc = []
       row = nil
       pdf417_getOutBits.each_with_index do |byte, n|
         if n%cols == 0
           row = ""
           enc << row
         end
         row << sprintf("%08b", (byte & 0xff) | 0x100)
       end
       @pdf417_paintCode_ret=nil
       enc
     end
#    def encoding
#      @pdf417.paintCode()
#
#      cols = (@pdf417.getBitColumns() - 1) / 8 + 1
#      enc = []
#      row = nil
#      @pdf417.getOutBits.each_with_index do |byte, n|
#        if n%cols == 0
#          row = ""
#          enc << row
#        end
#        row << sprintf("%08b", (byte & 0xff) | 0x100)
#      end
#      enc
#    end
  end
end