class PlayerValidDocModel {
  final String? docId;
  final String? playerId;
  final String documentType;
  final List<String> documentUrls;
  final String documentFormat;
  final String? uploadedAt;

  PlayerValidDocModel({
    required this.docId,
    required this.playerId,
    required this.documentType,
    required this.documentUrls,
    required this.documentFormat,
    required this.uploadedAt,
  });

  factory PlayerValidDocModel.fromMap(Map<String, dynamic> map) {
    return PlayerValidDocModel(
      docId: map['doc_id'],
      playerId: map['player_id'],
      documentType: map['document_type'],

      documentUrls: List<String>.from(map['document_urls'] as List),

      documentFormat: map['document_format'],
      uploadedAt: map['uploaded_at'] as String,
    );
  }

  factory PlayerValidDocModel.empty(String type, String format) {
    return PlayerValidDocModel(
      docId: null,
      playerId: null,
      documentType: type,
      documentUrls: [],
      documentFormat: format,
      uploadedAt: '',
    );
  }
}
