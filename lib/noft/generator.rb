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
  class FontBlast < Schmooze::Base
    dependencies fontBlast: 'font-blast'

    method :blast, 'function(fontFile, destinationFolder, userConfig) {fontBlast(fontFile, destinationFolder, userConfig);}'
  end

  module Generator
    class << self
      def generate_assets(icon_set_name, output_directory)
        icon_set = Noft.icon_set_by_name(icon_set_name)
        FileUtils.rm_rf output_directory

        # Generate filename mapping
        filenames = {}
        icon_set.icons.each { |icon| filenames[icon.unicode] = icon.name }

        # Actually run the font blast to extract out the svg files
        Noft::FontBlast.new(Dir.pwd).blast(icon_set.font_file, output_directory, { :filenames => filenames })

        # Node writes the file asynchronously. This needs to be in place to ensure
        # all the files are written as it is the last file to be generated
        wait_until { File.exist?("#{output_directory}/verify.html") }

        output_directory
      end

      private

      def wait_until(count = 100000, &block)
        i = count
        while i > 0
          if block.call
            break
          else
            i -= 1
            Thread.pass
          end
        end
      end
    end
  end
end
