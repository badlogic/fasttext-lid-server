#include <httplib.h>
#include "fasttext.h"
#include <string>
#include <iostream>
#include <sstream>

std::string stripLabel(const std::string &label) {
	const std::string prefix = "__label__";
	if (label.substr(0, prefix.length()) == prefix) {
		return label.substr(prefix.length());
	}
	return label;
}

int main(int argc, char *argv[]) {
	if (argc != 3) {
		std::cerr << "Usage: " << argv[0] << " <model_path> <port>" << std::endl;
		return 1;
	}

	fasttext::FastText ft;
	ft.loadModel(argv[1]);

	httplib::Server svr;

	svr.Get("/detect", [&ft](const httplib::Request &req, httplib::Response &res) {
		if (!req.has_param("text")) {
			res.status = 400;
			res.set_content("Missing text parameter", "text/plain");
			return;
		}

		auto text = req.get_param_value("text");
		std::istringstream iss(text);
		std::vector<std::pair<fasttext::real, std::string>> predictions;
		ft.predictLine(iss, predictions, 1, 0.0);

		if (predictions.empty()) {
			res.status = 500;
			res.set_content("Prediction failed", "text/plain");
			return;
		}

		std::string result = "{\"language\":\"" + stripLabel(predictions[0].second) +
							 "\",\"probability\":" + std::to_string(predictions[0].first) + "}";
		res.set_content(result, "application/json");
	});

	auto port = std::stoi(argv[2]);
	std::cout << "Starting server on port " << port << std::endl;
	svr.listen("0.0.0.0", port);
	return 0;
}