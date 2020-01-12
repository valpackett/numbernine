#include <epoxy/gl.h>

#include <iostream>

GLshort vertices[] = {
    -1, 1, 1, 1, -1, -1, 1, -1,
};

GLshort texcoords[] = {0, 0, 1, 0, 0, 1, 1, 1};

const GLchar *vertShader2d = R"(
#version 300 es
layout(location = 0) in mediump vec2 in_vertex;
layout(location = 1) in mediump vec2 in_texcoord;
out mediump vec2 texcoord;

void main() {
	gl_Position = vec4(in_vertex, 0.0, 1.0);
	texcoord = in_texcoord;
}
)";

const GLchar *fragShaderBlank = R"(
#version 300 es
out mediump vec4 frag_color;
in  mediump vec2 texcoord;

void main() {
	frag_color = vec4(texcoord, 0.4, 0.0);
}
)";

const GLchar *fragShaderTex = R"(
#version 300 es
out mediump vec4 frag_color;
in  mediump vec2 texcoord;
uniform sampler2D texture;

void main() {
	frag_color = texture2D(texture, texcoord);
}
)";

static GLuint mkVbo(GLshort *data, GLuint len) {
	GLuint vbo = 0;
	glGenBuffers(1, &vbo);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, len, data, GL_STATIC_DRAW);
	return vbo;
}

static GLuint mkVao() {
	GLuint vao = 0;
	glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);
	return vao;
}

static GLuint mkCompiledShader(const char *src, GLenum shaderTyp) {
	GLuint shader = glCreateShader(shaderTyp);
	glShaderSource(shader, 1, &src, nullptr);
	glCompileShader(shader);

	GLint status = GL_FALSE;
	glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
	if (status != GL_TRUE) {
		GLsizei log_length = 0;
		GLchar message[1024];
		glGetShaderInfoLog(shader, 1024, &log_length, message);
		std::cerr << "Shader compilation failed: " << message << std::endl;
		glDeleteShader(shader);
		return -1;
	}
	return shader;
}

static GLuint mkProg(const char *srcVert, const char *srcFrag) {
	auto vs = mkCompiledShader(srcVert, GL_VERTEX_SHADER);
	auto fs = mkCompiledShader(srcFrag, GL_FRAGMENT_SHADER);
	GLuint prog = glCreateProgram();
	glAttachShader(prog, fs);
	glAttachShader(prog, vs);
	glLinkProgram(prog);
	glDeleteShader(vs);
	glDeleteShader(fs);
	return prog;
}

static GLuint vao;
static GLuint vboVert;
static GLuint vboTexC;
static GLuint progBlank;
static GLuint progTex;

void n9_wallpaper_setup() {
	vao = mkVao();
	vboVert = mkVbo(vertices, sizeof(vertices));
	vboTexC = mkVbo(texcoords, sizeof(texcoords));

	glBindBuffer(GL_ARRAY_BUFFER, vboVert);
	glVertexAttribPointer(0, 2, GL_SHORT, GL_FALSE, 0, nullptr);
	glEnableVertexAttribArray(0);

	glBindBuffer(GL_ARRAY_BUFFER, vboTexC);
	glVertexAttribPointer(1, 2, GL_UNSIGNED_SHORT, GL_FALSE, 0, nullptr);
	glEnableVertexAttribArray(1);

	progBlank = mkProg(vertShader2d, fragShaderBlank);
	progTex = mkProg(vertShader2d, fragShaderTex);
}

uint32_t n9_wallpaper_upload_image(size_t width, size_t height, char *pixels) {
	GLuint tex;
	glGenTextures(1, &tex);
	glBindTexture(GL_TEXTURE_2D, tex);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixels);
	return static_cast<uint32_t>(tex);
}

void n9_wallpaper_deallocate_image(uint32_t tex) { glDeleteTextures(1, &tex); }

void n9_wallpaper_render_blank() {
	glUseProgram(progBlank);
	glBindVertexArray(vboVert);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void n9_wallpaper_render_image(uint32_t tex) {
	glUseProgram(progTex);
	glBindTexture(GL_TEXTURE_2D, static_cast<GLuint>(tex));
	glBindVertexArray(vboVert);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
