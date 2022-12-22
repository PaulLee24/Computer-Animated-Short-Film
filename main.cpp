#define GLM_ENABLE_EXPERIMENTAL

#include "Object.h"
#include "FreeImage.h"
#include "glew.h"
#include "freeglut.h"
#include "shader.h"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtx/transform.hpp"
#include "glm/glm.hpp"
#include "glm/gtc/type_ptr.hpp"
#include <iostream>
#include <string>
#include <math.h>
#include <stb_image.h>
#include <ctime>
#include <chrono>
#include <thread>
#include "Vertex.h"
#include <vector>

using namespace std;


void shaderInit();
void bindbufferInit();
void textureInit();
void display();
void idle();
void reshape(GLsizei w, GLsizei h);
void Demo(GLuint);
void LoadTexture(unsigned int&, const char*, int);
void keyboard(unsigned char key, int x, int y);

const double PI = 3.141592;
bool play = false;

GLuint Program;
GLuint VAO, VBO[3];
GLuint PikaVAO, PikaVBO[3];
unsigned int modeltexture, Pikatexture;
float windowSize[2] = { 600, 600 };
float angle = 0.0f;
float Time = 0;
glm::vec3 WorldLightPos = glm::vec3(2, 5, 5);
glm::vec3 WorldCamPos = glm::vec3(7.5, 5.0, 7.5);

Object* model = new Object("Eevee.obj");
Object* Pika = new Object("Pikachu.obj");

int main(int argc, char** argv) {
	glutInit(&argc, argv);
	glutInitWindowSize(windowSize[0], windowSize[1]);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
	glutCreateWindow("hw4");

	glewInit();
	shaderInit();
	bindbufferInit();
	textureInit();

	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutKeyboardFunc(keyboard);
	glutIdleFunc(idle);
	glutMainLoop();
	return 0;
}

void keyboard(unsigned char key, int x, int y) {
	switch (key) {
		case 'p':
		{
			play = !play;
			break;
		}
	
		default:
		{
			break;
		}
	}
}

void shaderInit() {
	GLuint vert = createShader("Shaders/expand3.vert", "vertex");
	GLuint goem = createShader("Shaders/expand3.geom", "geometry");
	GLuint frag = createShader("Shaders/expand3.frag", "fragment");
	Program = createProgram(vert, goem, frag);
}

void bindbufferInit() {
	glGenVertexArrays(1, &VAO);
	glGenBuffers(3, VBO);

	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, VBO[0]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(model->positions[0]) * model->positions.size(), &model->positions[0], GL_STATIC_DRAW);
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);

	glBindBuffer(GL_ARRAY_BUFFER, VBO[1]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(model->normals[0]) * model->normals.size(), &model->normals[0], GL_STATIC_DRAW);
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, (void*)0);

	glBindBuffer(GL_ARRAY_BUFFER, VBO[2]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(model->texcoords[0]) * model->texcoords.size(), &model->texcoords[0], GL_STATIC_DRAW);
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 0, (void*)0);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	glGenVertexArrays(1, &PikaVAO);
	glGenBuffers(3, PikaVBO);

	glBindVertexArray(PikaVAO);

	glBindBuffer(GL_ARRAY_BUFFER, PikaVBO[0]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Pika->positions[0]) * Pika->positions.size(), &Pika->positions[0], GL_STATIC_DRAW);
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);

	glBindBuffer(GL_ARRAY_BUFFER, PikaVBO[1]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Pika->normals[0]) * Pika->normals.size(), &Pika->normals[0], GL_STATIC_DRAW);
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, (void*)0);

	glBindBuffer(GL_ARRAY_BUFFER, PikaVBO[2]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Pika->texcoords[0]) * Pika->texcoords.size(), &Pika->texcoords[0], GL_STATIC_DRAW);
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 0, (void*)0);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);
}

void textureInit() {
	LoadTexture(modeltexture, "Eevee.jpg", 0);
	LoadTexture(Pikatexture, "Pikachu.png", 1);
}

glm::mat4 getV()
{
	// set camera position and configuration
	return glm::lookAt(glm::vec3(WorldCamPos.x, WorldCamPos.y, WorldCamPos.z), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0));
}

glm::mat4 getP()
{
	// set perspective view
	float fov = 45.0f;
	float aspect = windowSize[0] / windowSize[1];
	float nearDistance = 1.0f;
	float farDistance = 1000.0f;
	return glm::perspective(glm::radians(fov), aspect, nearDistance, farDistance);
}

void display() {
	//Clear the buffer
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glClearDepth(1.0f);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	Demo(Program);
	glutSwapBuffers();
}

void reshape(GLsizei w, GLsizei h) {
	windowSize[0] = w;
	windowSize[1] = h;
}


void LoadTexture(unsigned int& texture, const char* tFileName, int i) {
	glEnable(GL_TEXTURE_2D);
	glActiveTexture(GL_TEXTURE0 + i);
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	int width, height, nrChannels;
	stbi_set_flip_vertically_on_load(true);
	unsigned char* data = stbi_load(tFileName, &width, &height, &nrChannels, 0);

	if (data)
	{
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
	}
	else
	{
		cout << "Failed to load texture" << endl;
	}
	stbi_image_free(data);
}

void idle() {
	glutPostRedisplay();
}

void Demo(GLuint program)
{
	glUseProgram(program);

	if (play) {
		if (Time < 45) {
			angle += 0.01;
		}
		if (Time >= 55 && Time < 65) {
			angle += 0.01 + 0.05 * ((Time * Time) - 55 * 55) / (65 * 65 - 55 * 55);
		}
		/*if (Time >= 60 && Time < 65) {
			angle += 0.06 - 0.03 * ((Time * Time) - 60 * 60) / (65 * 65 - 60 * 60);
		}*/
		if (Time >= 75 && Time < 90) {
			angle += 0.024;
		}

		if (angle >= 360) {
			angle -= 360;
		}

		Time += 0.0006 * PI;
	}
	

	glm::mat4 M(1.0f);
	//M = glm::rotate(M, glm::radians(angle), glm::vec3(0, 1, 0));
	//M = glm::translate(M, glm::vec3(0, 0, 0));

	if (Time < 65) {
		M = glm::rotate(M, glm::radians(angle), glm::vec3(0, 1, 0));
		M = glm::translate(M, glm::vec3(0, -0.8, 0));
		M = glm::rotate(M, glm::radians(angle), glm::vec3(0, 1, 0));
		M = glm::rotate(M, glm::radians(90.0f), glm::vec3(1, 0, 0));
		M = glm::scale(M, glm::vec3(0.3, 0.3, 0.3));

		GLuint ModelMatrixID = glGetUniformLocation(program, "M");
		glUniformMatrix4fv(ModelMatrixID, 1, GL_FALSE, &M[0][0]);

		glm::mat4 V = getV();
		ModelMatrixID = glGetUniformLocation(program, "V");
		glUniformMatrix4fv(ModelMatrixID, 1, GL_FALSE, &V[0][0]);

		glm::mat4 P = getP();
		ModelMatrixID = glGetUniformLocation(program, "P");
		glUniformMatrix4fv(ModelMatrixID, 1, GL_FALSE, &P[0][0]);

		glUniform1f(glGetUniformLocation(program, "time"), Time);

		glUniform1i(glGetUniformLocation(program, "texture"), 0);

		glBindVertexArray(VAO);
		glDrawArrays(GL_TRIANGLES, 0, 3 * model->fNum);
		glBindVertexArray(0);
		glActiveTexture(0);
		glUseProgram(0);
	}

	else {
		float dirx, diry, dirz;
		dirx = rand();
		diry = rand();
		dirz = rand();
		dirx = dirx / sqrt(dirx * dirx + diry * diry + dirz * dirz);
		diry = diry / sqrt(dirx * dirx + diry * diry + dirz * dirz);
		dirz = dirz / sqrt(dirx * dirx + diry * diry + dirz * dirz);

		if (Time >= 102 && Time < 103) {
			if (int(Time * 100) % 30 == 0) {
				dirx = rand();
				diry = rand();
				dirz = rand();
				dirx = dirx / sqrt(dirx * dirx + diry * diry + dirz * dirz);
				diry = diry / sqrt(dirx * dirx + diry * diry + dirz * dirz);
				dirz = dirz / sqrt(dirx * dirx + diry * diry + dirz * dirz);
			}
			M = glm::translate(M, glm::vec3(dirx*0.1, diry*0.1, dirz*0.1));
		}

		M = glm::translate(M, glm::vec3(0, -1.5, 0));
		M = glm::rotate(M, glm::radians(angle), glm::vec3(0, 1, 0));
		M = glm::rotate(M, glm::radians(120.0f), glm::vec3(0, 1, 0));
		//M = glm::scale(M, glm::vec3(5, 5, 5));

		if (Time < 90) {
			M = glm::scale(M, glm::vec3(4, 4, 4));
		}
		else if (Time >= 90 && Time < 92) {
			float pikascale = 1 * (Time - 90) / 2;
			M = glm::scale(M, glm::vec3(4+pikascale, 4+pikascale, 4+pikascale));
		}
		else if (Time >= 92 && Time < 95) {
			float pikascale = -0.5 * (Time - 92) / 3;
			M = glm::scale(M, glm::vec3(5 + pikascale, 5 + pikascale, 5 + pikascale));
		}
		else if (Time >= 95 && Time < 97) {
			float pikascale = 1.5 * (Time - 95) / 2;
			M = glm::scale(M, glm::vec3(4.5 + pikascale, 4.5 + pikascale, 4.5 + pikascale));
		}
		else if (Time >= 97 && Time < 100) {
			float pikascale = -0.5 * (Time - 97) / 2;
			M = glm::scale(M, glm::vec3(6 + pikascale, 6 + pikascale, 6 + pikascale));
		}
		else if (Time >= 100 && Time < 101) {
			float pikascale = 1 * (Time - 100) / 1;
			M = glm::scale(M, glm::vec3(5.5 + pikascale, 5.5 + pikascale, 5.5 + pikascale));
		}
		else if (Time >= 101 && Time < 102) {
			float pikascale = 0.5 * (Time - 101) / 1;
			M = glm::scale(M, glm::vec3(6.5 + pikascale, 6.5 + pikascale, 6.5 + pikascale));
		}
		else if (Time >= 102 && Time < 103) {
			float pikascale = 0.3 * (Time - 102) / 1;
			M = glm::scale(M, glm::vec3(7 + pikascale, 7 + pikascale, 7 + pikascale));
		}
		else {
			M = glm::scale(M, glm::vec3(7.3, 7.3, 7.3));
		}

		GLuint ModelMatrixID = glGetUniformLocation(program, "M");
		glUniformMatrix4fv(ModelMatrixID, 1, GL_FALSE, &M[0][0]);

		glm::mat4 V = getV();
		ModelMatrixID = glGetUniformLocation(program, "V");
		glUniformMatrix4fv(ModelMatrixID, 1, GL_FALSE, &V[0][0]);

		glm::mat4 P = getP();
		ModelMatrixID = glGetUniformLocation(program, "P");
		glUniformMatrix4fv(ModelMatrixID, 1, GL_FALSE, &P[0][0]);

		glUniform1f(glGetUniformLocation(program, "time"), Time);

		glUniform1i(glGetUniformLocation(program, "texture"), 1);

		glBindVertexArray(PikaVAO);
		glDrawArrays(GL_TRIANGLES, 0, 3 * Pika->fNum);
		glBindVertexArray(0);
		glActiveTexture(0);
		glUseProgram(0);
	}	
}
