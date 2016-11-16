require 'base64'
require 'http'
require 'nokogiri'

class Putao
  # @param passkey [String]
  # @param user_id [Integer]
  def initialize(passkey:, user_id:)
    @user_id = user_id
    @cookies = {
      c_secure_pass: passkey,
      c_secure_login: URI.encode( Base64.strict_encode64('nope'), '='),
      c_secure_uid: URI.encode( Base64.strict_encode64(user_id.to_s), '=')
    }
  end

  # @return [MessageManager]
  def messages
    @message_manager ||= MessageManager.new(cookies: @cookies)
  end

  class Message
    attr_reader :id, :sender_id, :time

    # @param title [String]
    # @param id [Integer] message ID
    # @param sender_id [Integer, :system] sender ID, or +:system+
    # @param time [Time] the time of the message
    def initialize(title:, id:, sender_id:, time:)
      @title = title
      @id = id
      @sender_id = sender_id
      @time = time
    end
  end

  class MessageManager
    FULL_PATH = 'https://pt.sjtu.edu.cn/messages.php'

    # @param cookies [Hash{Symbol => String}] the cookies
    def initialize(cookies:)
      @cookies = cookies
    end

    # Gets a page of messages.
    #
    # At the page of the box (inbox, sent, or custom box), the +box+ parameter is the corresponding ID.
    #
    # @param box_id [Integer] index of the box. 1 for inbox, -1 for sent mail.
    # @return [Array<Message>] the messages
    def all(box_id: 1)
      get_document_with_params(
        action: 'viewmailbox',
        box: box_id
      ).xpath('//form[@method="post"]//tr')[1..-3].map do |tr|
        msg_link = tr.element_children[1].element_children.first
        Message.new(
          title: msg_link.child.to_s,
          id: URI.decode_www_form(URI.parse(msg_link['href']).query).to_h['id'],
          sender_id: get_sender(tr),
          time: Time.parse(tr.element_children[3].child.to_s + '+0800')
        )
      end
    end

    # Gets a page of messages matching the exact given title.
    #
    # At the page of the box (inbox, sent, or custom box), the +box+ parameter is the corresponding ID.
    #
    # @param title [String] exact title of the message
    # @param box_id [Integer] index of the box. 1 for inbox, -1 for sent mail.
    # @return [Array<Message>] the messages matching the title
    def matching(title, box_id: 1)
      get_document_with_params(
        action: 'viewmailbox',
        keyword: title,
        place: 'title',
        box: box_id
      ).xpath('//form[@method="post"]//tr')[1..-3].map do |tr|
        msg_link = tr.element_children[1].element_children.first
        if msg_link.child.to_s == title
          Message.new(
            title: msg_link.child.to_s,
            id: URI.decode_www_form(URI.parse(msg_link['href']).query).to_h['id'],
            sender_id: get_sender(tr),
            time: Time.parse(tr.element_children[3].child.to_s + '+0800')
          )
        else
          nil
        end
      end.compact
    end

    # @param params [Hash{Symbol => String}] the parameters of the HTTP query
    # @return [Nokogiri::HTML::Document] the parsed document
    def get_document_with_params(params)
      # @type r [HTTP::Response] the response
      r = HTTP.cookies(@cookies).get(FULL_PATH, params: params)

      Nokogiri::HTML(r.body.to_s)
    end

    # @param tr [Nokogiri::XML::Element]
    # @return [Integer, :system] sender ID, or +:system+
    def get_sender(tr)
      # @type td [Nokogiri::XML::Element]
      td = tr.element_children[2]

      if td.child.is_a?(Nokogiri::XML::Text)
        :system
      else
        URI.decode_www_form(URI.parse(td.xpath('.//a/@href').to_s).query).to_h['id']
      end
    end
  end
end
