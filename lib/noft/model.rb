#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Noft
  module ArtifactDSL
    include Reality::Generators::ArtifactDSL

    def template_set_container
      Noft::Generator
    end
  end

  module FacetManager
    extend Reality::Facets::FacetContainer
  end

  module Generator #nodoc
    class << self
      include Reality::Generators::TemplateSetContainer

      def derive_default_helpers(options)
        helpers = []
        helpers
      end
    end
  end

  module Model #nodoc
  end

  FacetManager.extension_manager.singleton_extension(ArtifactDSL)

  Reality::Model::Repository.new(:Noft,
                                 Noft::Model,
                                 :instance_container => Noft,
                                 :facet_container => Noft::FacetManager,
                                 :log_container => Noft) do |r|
    r.model_element(:icon_set)
    r.model_element(:icon, :icon_set)
  end

  module Model #nodoc
    class IconSet
      # A human readable name for icon set
      attr_accessor :display_string
      attr_accessor :description
      # The version of the source library from which this was extracted
      attr_accessor :version
      # The url to the source library
      attr_accessor :url
      # The license of the library
      attr_accessor :license
      # The url of the license
      attr_accessor :license_url
      # The local filename of the font file
      attr_accessor :font_file

      def write_to(filename)
        File.write(filename, JSON.pretty_generate(to_h) + "\n")
      end

      def to_h
        data = {}
        data[:name] = self.name
        data[:display_string] = self.display_string if self.display_string
        data[:description] = self.description if self.description
        data[:version] = self.version if self.version
        data[:url] = self.url if self.url
        data[:license] = self.license if self.license
        data[:license_url] = self.license_url if self.license_url

        data[:icons] = {}
        self.icons.each do |icon|
          data[:icons][icon.name] = icon.to_h
        end

        data
      end
    end

    class Icon
      # A human readable name for icon
      attr_accessor :display_string
      attr_accessor :description

      # The unicode that it was assigned inside the font.
      attr_accessor :unicode

      def qualified_name
        "#{self.icon_set.name}-#{self.name}"
      end

      # Categories which this Icon exists. Useful when displaying an icon sheet.
      def categories
        @categories ||= []
      end

      # Alternative aliases under which this icon may be known.
      def aliases
        @aliases ||= []
      end

      def to_h
        data = {}
        data[:display_string] = self.display_string if self.display_string
        data[:description] = self.description if self.description
        data[:aliases] = self.aliases unless self.aliases.empty?
        data[:categories] = self.categories unless self.categories.empty?

        data
      end
    end
  end
end
