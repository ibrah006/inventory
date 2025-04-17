class PricingList {
  double? web, premium, retail, wholesale, referral;

  PricingList(
      {this.web, this.premium, this.retail, this.wholesale, this.referral});

  factory PricingList.fromJson(Map<String, dynamic> json) {
    return PricingList(
        web: json["web"],
        premium: json["premium"],
        retail: json["retail"],
        wholesale: json["wholesale"],
        referral: json["referral"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "web": web,
      "premium": premium,
      "retail": retail,
      "wholesale": wholesale,
      "referral": referral
    };
  }
}
