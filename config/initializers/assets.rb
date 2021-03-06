# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[
  image_form_virtual.js
  copy_to_clipboard.js
  post_text_box.js
  schedule_text_box.js
  comment_text_box.js
  datetimepicker.js
  tweet_text_box.js
  image_edit_modal.js
  watching_posts.js
  newest_posts.js
  note_foot_toolbar.js
  jquery.contenteditable.placeholder.js
  jquery.text-with-lf.js
]

# Original Webfonts
Rails.application.config.assets.paths <<
  Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.paths <<
  Rails.root.join('app', 'assets', 'images', 'help')
Rails.application.config.assets.paths <<
  Rails.root.join('app', 'assets', 'images', 'shinchoku_stamps')
Rails.configuration.assets.precompile += %w[serviceworker.js manifest.json]
