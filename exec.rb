require 'bundler/inline'
require 'securerandom'

gemfile do
  source 'https://rubygems.org'
  gem 'faker', require: true
  gem 'spreadsheet_architect', require: true
end

OUTPUT_DIR = "./samples"

SURVEY_UID = SecureRandom.uuid
QUESTIONNAIRE_ID = "S032w"
CHOICE_QUESTION_ID = "S032w.Q.63"
FREE_QUESTION_ID = "S032w.Q.64"
RESPONDENT_ID = SecureRandom.uuid
A1_ID = SecureRandom.uuid
A2_ID = SecureRandom.uuid
A3_ID = SecureRandom.uuid

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
      keywords: "Branches of service, Deferment and the Selective Service System, Desire for combat and service overseas, Infantry - opinion of, Leisure-time activities, Medical attention, Moral questions, Officers — commissioned and non-commissioned, Officer Candidate School — interest in, Post-war optimism — pessimism, Red Cross, Religion and church attendance, Segregation of white and Negro soldiers in PX"
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
      question: "Do you think white and Negro soldiers should be in separate outfits or should they be together in the same outfit?",
      is_multiple_choice: true,
      followup_prompt: "Write any comments here"
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
      parent_id: CHOICE_QUESTION_ID,
      code: "01",
      text: "SEPARATE OUTFITS OUT OF DEFERENCE TO SOUTHERN CUSTOMS (IT’S O.K. FOR SOUTH, BUT NOT FOR NORTH, NOT WHERE THIS CAMP IS LOCATED)",
    },
    {
      parent_id: CHOICE_QUESTION_ID,
      code: "01",
      text: "SEPARATE OUTFITS BECAUSE INTERMINGLING WOULD LEAD TO VIOLENCE, FIGHTS, TROUBLE",
    },
    {
      parent_id: CHOICE_QUESTION_ID,
      code: "03",
      text: "SEPARATE OUTFITS BECAUSE NEGROES THEMSELVES (OR BOTH NEGROES AND WHITES) LIKE IT BETTER THAT WAY (NEGROES FEEL UNCOMFORTABLE WITH WHITES, NEGROES FEEL MORE AT HOME WITH OWN RACE)"
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
      image: "2521127-09-0004.jpg"
    },
    {
      identifier: SecureRandom::uuid,
      question_id: FREE_QUESTION_ID,
      respondent_id: RESPONDENT_ID,
      answer_id: nil,
      free_response_answer: "In reference to question #25 there is no cooperation with anybody at all including officers, NCO's & enlisted men. I know I would never come back alive if sent into combat with the company I am in now. I know it a heck of a thing to say, but it's the truth.",
      image: "2521127-09-0004.jpg"
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
