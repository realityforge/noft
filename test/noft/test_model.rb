require File.expand_path('../../helper', __FILE__)

class TestModel < Noft::TestCase
  def test_to_h

    Noft.icon_set(:fa) do |s|
      s.display_string = 'Font Awesome'
      s.description = 'The iconic font and CSS toolkit'
      s.version = '4.3.2'
      s.url = 'http://fontawesome.io'
      s.license = 'SIL Open Font License (OFL)'
      s.license_url = 'http://scripts.sil.org/OFL'

      # Font file ignored
      s.font_file = 'webfont.svg'

      s.icon(:'map-marker') do |i|
        i.display_string = 'The nice map marker'

        # unicode ignored
        i.unicode = 'f041'
        i.categories << 'Map Icons'
        i.categories << 'Web App Icons'
        i.aliases << 'map-point'
        i.aliases << 'poi'
      end

      s.icon(:cross) do |i|
        i.unicode = 'f022'
        i.categories << 'Web App Icons'
      end
    end

    icon_set = Noft.icon_set_by_name(:fa)

    expected =
      {
        :name => :fa,
        :displayString => 'Font Awesome',
        :description => 'The iconic font and CSS toolkit',
        :version => '4.3.2',
        :url => 'http://fontawesome.io',
        :license => 'SIL Open Font License (OFL)',
        :licenseUrl => 'http://scripts.sil.org/OFL',
        :icons =>
          {
            :'map-marker' =>
              {
                :displayString => 'The nice map marker',
                :aliases => %w(map-point poi),
                :categories => ['Map Icons', 'Web App Icons'],
                :unicode => 'f041'
              },
            :cross => { :categories => ['Web App Icons'], :unicode => 'f022' } } }

    assert_equal expected, icon_set.to_h
  end

  def test_write_then_read
    Noft.icon_set(:fa) do |s|
      s.display_string = 'Font Awesome'
      s.description = 'The iconic font and CSS toolkit'
      s.version = '4.3.2'
      s.url = 'http://fontawesome.io'
      s.license = 'SIL Open Font License (OFL)'
      s.license_url = 'http://scripts.sil.org/OFL'

      # Font file ignored
      s.font_file = 'webfont.svg'

      s.icon(:'map-marker') do |i|
        i.display_string = 'The nice map marker'

        # unicode ignored
        i.unicode = 'f041'
        i.categories << 'Map Icons'
        i.categories << 'Web App Icons'
        i.aliases << 'map-point'
        i.aliases << 'poi'
      end

      s.icon(:cross) do |i|
        i.unicode = 'f022'
        i.categories << 'Web App Icons'
      end
    end

    icon_set = Noft.icon_set_by_name(:fa)

    filename = create_filename('.json')
    icon_set.write_to(filename)

    Noft.reset

    icon_set_2 = Noft.read_model(filename)

    assert_equal icon_set.name, icon_set_2.name
    assert_equal icon_set.to_h, icon_set_2.to_h
    assert_equal nil, icon_set_2.font_file
    assert_equal 'f041', icon_set_2.icon_by_name('map-marker').unicode
    assert_equal 'f022', icon_set_2.icon_by_name('cross').unicode
  end

  def test_filtering_read
    filename = create_filename('.json')
    Noft.icon_set(:fa) do |s|
      s.icon(:a)
      s.icon(:b)
      s.icon(:c)
    end.write_to(filename)

    Noft.reset
    icon_set = Noft.read_model(filename)
    assert_equal icon_set.icon_names.sort, %w(a b c)

    Noft.reset
    icon_set = Noft.read_model(filename, %w(b c d e))
    assert_equal icon_set.icon_names.sort, %w(b c)

    Noft.reset
    filter = Proc.new { |icon_name| %w(a c x).include?(icon_name) }
    icon_set = Noft.read_model(filename, filter)
    assert_equal icon_set.icon_names.sort, %w(a c)
  end

  def test_font_file?
    Noft.icon_set(:fa) do |s|
      assert_false s.font_file?

      s.font_file = 'webfont.svg'

      assert_true s.font_file?
    end
  end
end
