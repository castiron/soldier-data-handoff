require 'bundler/inline'
require 'securerandom'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faker', require: true
  gem 'spreadsheet_architect', require: true
end

OUTPUT_DIR = "./samples"

SURVEY_UID = SecureRandom.uuid
QUESTIONNAIRE_ID = "S032w"
CHOICE_QUESTION_ID = "S032w.Q.63"
CHOICE_QUESTION_ID_2 = "S032w.Q.64"
FREE_QUESTION_ID = "S032w.Q.64"
RESPONDENT_ID = SecureRandom.uuid
A1_ID = SecureRandom.uuid
A2_ID = SecureRandom.uuid
A3_ID = SecureRandom.uuid
A4_ID = SecureRandom.uuid
A5_ID = SecureRandom.uuid
TAG_1_ID = SecureRandom.uuid
TAG_2_ID = SecureRandom.uuid

SHEETS = {
  surveys: [
    {
      identifier: SURVEY_UID,
      designation: "Planning Survey II",
      location: "US",
      date: "05/41",
      topics: "Attitudes in 3 divisions",
      sample_size: "4000",
      number: nil,
      topic: nil,
      keywords: "Branches of service, Deferment and the Selective Service  [...]"
    }
  ],
  questionnaires: [
    {
      identifier: QUESTIONNAIRE_ID,
      survey_identifier: SURVEY_UID,
      name: "Sch A1",
      keywords: "Financial status of soldiers, etc.",
      reel: 1,
      question_count: nil,
      image_range: "0001-0653",
      image_count: 653,
    },
    {
      identifier: SecureRandom.uuid,
      survey_identifier: SURVEY_UID,
      name: "Revised",
      keywords: "Civilian treatment of soldiers, Comic strips men prefer, Laundry Service, etc.",
      reel: 1,
      question_count: 118,
      image_range: "0654-1688",
      image_count: 1034,
    },
    {
      identifier: SecureRandom.uuid,
      survey_identifier: SURVEY_UID,
      name: "Sch B1/C1/C2",
      keywords: "Civilian treatment of soldiers, Comic strips men prefer, Laundry Service, etc.",
      reel: 2,
      question_count: nil,
      image_range: "0001-0801",
      image_count: 801,
    }
  ],
  questions: [
    {
      identifier: CHOICE_QUESTION_ID,
      parent_id: QUESTIONNAIRE_ID,
      parent_type: "questionnaire",
      position_in_parent: 1,
      type: "choice",
      question: "A choice question that alllows multiple choices to be selected and has an attached free response prompt...",
      is_multiple_choice: true,
      followup_prompt: "Write any comments here"
    },
    {
      identifier: CHOICE_QUESTION_ID_2,
      parent_id: QUESTIONNAIRE_ID,
      parent_type: "questionnaire",
      position_in_parent: 2,
      type: "choice",
      question: "Another choice question with only one answer allowed and no free response prompt...",
      is_multiple_choice: false,
    },
    {
      identifier: FREE_QUESTION_ID,
      parent_id: QUESTIONNAIRE_ID,
      parent_type: "questionnaire",
      position_in_parent: 2,
      type: "free",
      question: "Use the space below to write out any other comments you have about any part of this questionnaire:",
      is_multiple_choice: false,
      followup_prompt: nil,
    }
  ],
  question_codes: [
    {
      identifier: "#{CHOICE_QUESTION_ID}-code01",
      parent_id: CHOICE_QUESTION_ID,
      code: "01",
      text: "SEPARATE OUTFITS OUT OF DEFERENCE TO SOUTHERN CUSTOMS  [...]",
    },
    {
      identifier: "#{CHOICE_QUESTION_ID}-code02",
      parent_id: CHOICE_QUESTION_ID,
      code: "02",
      text: "SEPARATE OUTFITS BECAUSE INTERMINGLING WOULD LEAD TO VIOLENCE, FIGHTS, TROUBLE",
    },
    {
      identifier: "#{CHOICE_QUESTION_ID}-code03",
      parent_id: CHOICE_QUESTION_ID,
      code: "03",
      text: "SEPARATE OUTFITS BECAUSE NEGROES THEMSELVES (OR BOTH NEGROES AND WHITES) LIKE IT BETTER [...]"
    }
  ],
  answers: [
    {
      identifier: A1_ID,
      question_id: CHOICE_QUESTION_ID,
      label: "They should be in separate outfits",
      position: 1
    },
    {
      identifier: A2_ID,
      question_id: CHOICE_QUESTION_ID,
      label: "They should be together in the same outfit",
      position: 2
    },
    {
      identifier: A3_ID,
      question_id: CHOICE_QUESTION_ID,
      label: "It doesn't make any difference, Undecided",
      position: 3
    },
    {
      identifier: A4_ID,
      question_id: CHOICE_QUESTION_ID_2,
      label: "An answer",
      position: 1
    },
    {
      identifier: A5_ID,
      question_id: CHOICE_QUESTION_ID_2,
      label: "Another",
      position: 2
    }
  ],
  respondents: [
    {
      identifier: RESPONDENT_ID,
      parent_id: SURVEY_UID,
      parent_type: "survey"
    },
    {
      identifier: SecureRandom.uuid,
      parent_id: SURVEY_UID,
      parent_type: "survey"
    },
    {
      identifier: SecureRandom.uuid,
      parent_id: QUESTIONNAIRE_ID,
      parent_type: "questionnaire"
    }
  ],
  responses: [
    {
      identifier: SecureRandom::uuid,
      question_id: CHOICE_QUESTION_ID,
      respondent_id: RESPONDENT_ID,
      answer_id: A1_ID,
      free_response_answer: "If separated there wouldn't be any fights",
      zooniverse_choice_answer_data: { "#{CHOICE_QUESTION_ID}": A1_ID, "#{CHOICE_QUESTION_ID_2}": A4_ID }.to_json,
      image: "2521127-09-0005.jpg",
      code_id: "#{CHOICE_QUESTION_ID}-code03",
      tags: TAG_1_ID
    },
    {
      identifier: SecureRandom::uuid,
      question_id: FREE_QUESTION_ID,
      respondent_id: RESPONDENT_ID,
      answer_id: nil,
      free_response_answer: "In reference to question #25 there is no cooperation [...]",
      zooniverse_choice_answer_data: nil,
      image: "2521127-09-0004.jpg",
      code_id: "#{CHOICE_QUESTION_ID}-code02",
      tags: "#{TAG_1_ID}, #{TAG_2_ID}"
    }
  ],
  tags: [
    {
      identifier: TAG_1_ID,
      tag: "Race",
      is_expert_tag: true
    },
    {
      identifier: TAG_2_ID,
      tag: "Food",
      is_expert_tag: false
    }

  ]
}

def clean_output_dir
  Dir.foreach(OUTPUT_DIR) do |f|
    fn = File.join(OUTPUT_DIR, f)
    File.delete(fn) if f != '.' && f != '..'
  end
end

def make_csv
  SHEETS.each do |key, sheet|
    File.open("#{OUTPUT_DIR}/#{key}.csv", 'w+b') do |f|
      f.write SpreadsheetArchitect.to_csv(headers: sheet[0].keys, data: sheet.map(&:values))
    end
  end
end

clean_output_dir
make_csv
