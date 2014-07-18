FactoryGirl.define do
  trait :initialize do
    after(:build) do
      GollumRails::Setup.build do |config|
        GollumRails::Setup.repository = File.expand_path('../utils/wiki.git', __FILE__)
      end
    end
  end
  trait :markdown do
    format :markdown
  end
  trait :mediawiki do
    format :mediawiki
  end
  factory :commit_fakes, class: DefaultCommit do
    sequence :commit do |num|
      { name: "mosny#{num}", message: "message number: #{num}", email: "mosny@zyg.li"}
    end
    initialize_with { attributes }
  end
  #factory :commit_fakes, class: DefaultCommit do
  #end
  factory :gollum_page_spec, traits: [:initialize, :markdown] do
    name "Goole"
    content "content data. content data. content data."
    commit { {name: "mosny", message: "commit message", email: "mosny@zyg.li"} }
    initialize_with { GollumPageSpec.new(attributes) }
  end
  factory :other_committer, class: GollumPageSpec, traits: [:initialize, :markdown] do
    name "Google"
    content "content data. content data. content data."
    commit { {name: "flo", message: "other commit message", email: "info@zyg.li"} }
    initialize_with { GollumPageSpec.new(attributes) }
  end
end
