$:.unshift File.expand_path('../../lib', __FILE__)

require 'securerandom'
require 'minitest/autorun'
require 'test/unit/assertions'
require 'noft'

module Noft
  class << self
    def reset
      self.send(:icon_set_map).clear
    end
  end
end

class Noft::TestCase < Minitest::Test
  include Test::Unit::Assertions

  def setup
    @base_temp_dir ||= ENV['TEST_TMP_DIR'] || File.expand_path("#{File.dirname(__FILE__)}/../tmp")
    @temp_dir = "#{@base_temp_dir}/#{name}"
    FileUtils.mkdir_p @temp_dir

    Noft.reset
  end

  def teardown
    FileUtils.rm_rf @base_temp_dir if File.exist?(@base_temp_dir)
  end

  def create_file(filename, content)
    expanded_filename = "#{working_dir}/#{filename}"
    FileUtils.mkdir_p File.dirname(expanded_filename)
    File.write(expanded_filename, content)
    expanded_filename
  end

  def create_filename(extension = '')
    "#{working_dir}/#{SecureRandom.hex}#{extension}"
  end

  def working_dir
    @temp_dir
  end

  # The base test directory
  def test_dir
    @test_dir ||= File.expand_path("#{File.dirname(__FILE__)}")
  end

  # The fixtures directory
  def fixture_dir
    "#{test_dir}/fixtures"
  end

  def fixture(filename)
    "#{fixture_dir}/#{filename}"
  end

  def load_sample1_icon_set
    # Load data from fixture json and make sure we link up all the non persisted attributes

    icon_set = Noft.read_model(fixture('sample1/fonts.json'))
    icon_set.font_file = fixture('sample1/webfont.svg')

    icon_set.icon_by_name('fire-extinguisher').unicode = 'f100'
    icon_set.icon_by_name('fire-symbol').unicode = 'f101'
    icon_set.icon_by_name('fire').unicode = 'f102'

    icon_set
  end
end
