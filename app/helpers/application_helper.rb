module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.update 'flash', partial: 'flash'
  end

  def default_meta_tags
    {
      site: '英語でどういう？ノート',
      reverse: true,
      charset: 'utf-8',
      description: '英語でどういう？ノートは、フレーズの翻訳と記録を同時にできるアプリです。',
      keywords: '英語でどういう？ノート, eigodedouiu, 英語, どう言う, Do you know, ノート',
      og: {
        title: :title,
        type: 'website',
        site_name: '英語でどういう？ノート',
        description: :description,
        image: image_url('ogp.png'),
        url: 'https://do-you-know-the-phrase.com',
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@lfax8dSjEK1wmvy'
      }
    }
  end
end
