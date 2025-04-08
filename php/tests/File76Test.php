<?php
use PHPUnit\Framework\TestCase;
use Demo\File76;

class File76Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File76::add(2, 3));
    }
}
