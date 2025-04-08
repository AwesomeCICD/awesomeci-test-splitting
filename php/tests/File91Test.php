<?php
use PHPUnit\Framework\TestCase;
use Demo\File91;

class File91Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File91::add(2, 3));
    }
}
