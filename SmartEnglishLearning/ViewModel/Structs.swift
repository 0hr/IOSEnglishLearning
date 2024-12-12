//
//  Structs.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/11/24.
//


struct UserResponse: Codable {
    let accessToken: String
    let tokenType: String
    let level: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case level, name, email
    }
}

struct ErrorResponse: Decodable {
    let detail: String
}

struct QuizResponse: Decodable {
    let success: Bool
    let data: [QuestionData]
}

struct QuestionData: Decodable {
    let correctOption: Int
    let id: Int
    let question: String
    let category: String
    let options: [OptionData]

    enum CodingKeys: String, CodingKey {
        case correctOption = "correct_option"
        case id, question, category, options
    }
}

struct OptionData: Decodable {
    let questionID: Int
    let option: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case option, id
    }
}

struct Question: Decodable {
    let id: Int
    let questionText: String
    let options: [String]
    let correctOptionIndex: Int
}

extension Question {
    static func mockQuestions() -> [Question] {
        return [
            Question(
                id: 1,
                questionText: "What is the capital of France?",
                options: ["Paris", "London", "Berlin", "Madrid"],
                correctOptionIndex: 0
            ),
            Question(
                id: 2,
                questionText: "What is the capital of Germany?",
                options: ["Paris", "London", "Berlin", "Madrid"],
                correctOptionIndex: 2
            )
        ]
    }
}
