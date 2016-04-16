module QuestionsHelper
	# For Q&A Forum
  def question_title(page_title = '')
    base_title = "Q&A Forum"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
