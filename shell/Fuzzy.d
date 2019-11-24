module Fuzzy;

/* Algorithm ported from https://github.com/jhawthorn/fzy

Copyright (c) 2014 John Hawthorn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. */

import std.algorithm : max;
import std.range : chunks, enumerate;
import std.typecons : No;
import std.string : indexOf;
import std.uni : toLower;

enum SCORE_MIN = -double.infinity;
enum SCORE_MAX = double.infinity;
enum SCORE_GAP_LEADING = -0.005;
enum SCORE_GAP_TRAILING = -0.005;
enum SCORE_GAP_INNER = -0.01;
enum SCORE_MATCH_CONSECUTIVE = 1.0;
enum SCORE_MATCH_SLASH = 0.9;
enum SCORE_MATCH_WORD = 0.8;
enum SCORE_MATCH_CAPITAL = 0.7;
enum SCORE_MATCH_DOT = 0.6;

enum bonus_index = makeBonusIndex();
enum bonus_states = makeBonusStates();

pure size_t[256] makeBonusIndex() {
	size_t[256] bi;
	foreach (i; 0 .. 256)
		bi[i] = 0;
	foreach (c; 'A' .. 'Z' + 1)
		bi[c] = 2;
	foreach (c; 'a' .. 'z' + 1)
		bi[c] = 1;
	foreach (c; '0' .. '9' + 1)
		bi[c] = 1;
	return bi;
}

pure double[256][3] makeBonusStates() {
	double[256][3] bs;
	foreach (i; 0 .. 3)
		foreach (j; 0 .. 256)
			bs[i][j] = 0;
	foreach (i; 1 .. 3)
		bs[i]['/'] = SCORE_MATCH_SLASH;
	foreach (i; 1 .. 3)
		bs[i]['-'] = SCORE_MATCH_WORD;
	foreach (i; 1 .. 3)
		bs[i]['_'] = SCORE_MATCH_WORD;
	foreach (i; 1 .. 3)
		bs[i][' '] = SCORE_MATCH_WORD;
	foreach (i; 1 .. 3)
		bs[i]['.'] = SCORE_MATCH_DOT;
	foreach (c; 'a' .. 'z' + 1)
		bs[2][c] = SCORE_MATCH_CAPITAL;
	return bs;
}

pure bool hasMatch(string needle, string haystack) {
	foreach (nch; needle) {
		auto idx = indexOf(haystack, nch, No.caseSensitive);
		if (idx == -1) {
			return 0;
		}
		haystack = haystack[idx .. $];
	}
	return 1;
}

pure double match(string needle, string haystack)
in(hasMatch(needle, haystack)) {
	auto n = needle.length;
	auto m = haystack.length;
	if (n == m || n == 0 || m == 0) {
		return SCORE_MAX;
	}
	auto need = needle.toLower;
	auto hay = haystack.toLower;
	auto D = new double[n * m].chunks(m);
	auto M = new double[n * m].chunks(m);
	auto match_bonus = new double[m];

	// precompute_bonus
	dchar last_ch = '/';
	foreach (i, ch; haystack.enumerate) {
		match_bonus[i] = bonus_states[bonus_index[ch]][last_ch];
		last_ch = ch;
	}

	for (int i = 0; i < n; i++) {
		double prev_score = SCORE_MIN;
		double gap_score = i == n - 1 ? SCORE_GAP_TRAILING : SCORE_GAP_INNER;

		for (int j = 0; j < m; j++) {
			if (need[i] == hay[j]) {
				double score = SCORE_MIN;
				if (!i) {
					score = (j * SCORE_GAP_LEADING) + match_bonus[j];
				} else if (j) { /* i > 0 && j > 0*/
					score = max(M[i - 1][j - 1] + match_bonus[j], /* consecutive match, doesn't stack with match_bonus */
							D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE);
				}
				D[i][j] = score;
				M[i][j] = prev_score = max(score, prev_score + gap_score);
			} else {
				D[i][j] = SCORE_MIN;
				M[i][j] = prev_score = prev_score + gap_score;
			}
		}
	}
	return M[n - 1][m - 1];
}
