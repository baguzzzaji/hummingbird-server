require 'stream_sync'

namespace :stream do
  namespace :sync do
    desc 'Synchronize followers to Stream'
    task follows: :environment do
      StreamSync.follows
    end

    desc 'Synchronize automatic (under-the-hood) follows to Stream'
    task auto_follows: :environment do
      StreamSync.follow_timeline
      StreamSync.follow_global
      StreamSync.follow_user_aggr

      [Anime, Manga, Drama].each do |type|
        StreamSync.follow_media_aggr(type)
      end
    end

    desc 'Synchronize media genres'
    task media_genres: :environment do
      StreamSync.media_genres
    end

    desc 'Synchronize media categories'
    task media_categories: :environment do
      StreamSync.media_categories
    end
  end

  namespace :dump do
    task load_dumper: :environment do
      require 'stream_dump'
    end

    namespace :split do
      desc 'Dump split profiles'
      task profiles: :load_dumper do
        StreamDump.split_profiles.each { |instr| STDOUT.puts instr.to_json }
      end

      desc 'Dump split media'
      task media: :load_dumper do
        StreamDump.split_media.each { |instr| STDOUT.puts instr.to_json }
      end

      desc 'Dump split timelines'
      task timeline: :load_dumper do
        StreamDump.split_timelines.each { |instr| STDOUT.puts instr.to_json }
      end
    end

    desc 'Dump posts in the mass import format for Stream'
    task posts: :load_dumper do
      StreamDump.posts.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump all stories in the mass import format for Stream'
    task stories: :load_dumper do
      StreamDump.stories.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump automatic follows'
    task auto_follows: :load_dumper do
      StreamDump.auto_follows.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump follows'
    task follows: :load_dumper do
      StreamDump.follows.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump group stuff'
    task groups: :load_dumper do
      ApplicationRecord.logger = Logger.new(nil)
      StreamDump.group_posts.each { |instr| STDOUT.puts instr.to_json }
      StreamDump.group_memberships.each { |instr| STDOUT.puts instr.to_json }
      StreamDump.group_auto_follows.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump group timeline migration'
    task group_timeline: :load_dumper do
      ApplicationRecord.logger = Logger.new(nil)
      StreamDump.group_timeline_migration.each do |instr|
        STDOUT.puts instr.to_json
      end
    end

    desc 'Dump library base'
    task private_library: :load_dumper do
      ApplicationRecord.logger = Logger.new(nil)
      StreamDump.private_library_feed.each do |instr|
        STDOUT.puts instr.to_json
      end
    end
  end
end
